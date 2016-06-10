require "kemal"
require "./anyquestion/*"

registry = Anyquestion::Registry.new

messages = [] of String
sockets = [] of HTTP::WebSocket

macro in_layout(tpl)
  render "views/#{{{tpl}}}.ecr", "views/layout.ecr"
end

get "/" do |env|
  in_layout "home"
end

get "/help" do
  in_layout "help"
end

post "/room" do |env|
  name = env.params.body["name"]
  room = Anyquestion::Room.new(name)
  registry.add room
  render "views/room.ecr"
end

get "/room/:id" do |env|
  begin
    id = env.params.url["id"].to_i
    if registry.rooms[id]?
      room = registry.rooms[id]
      render "views/room.ecr"
    else
      env.response.status_code = 404
    end
  rescue
    env.response.status_code = 404
  end
end

ws "/room" do |socket|
  sockets.push socket

  socket.on_message do |message|
    messages.push message
    sockets.each do |a_socket|
      begin
        a_socket.send messages.to_json
      rescue ex
        sockets.delete a_socket
      end
    end
  end

  socket.on_close do |socket|
    sockets.delete socket
  end
end

error 404 do
  in_layout "404"
end

Kemal.run
