require "kemal"
require "./anyquestion/*"

registry = Anyquestion::Registry.new

messages = [] of String
sockets = [] of HTTP::WebSocket

get "/" do |env|
  render "views/home.ecr", "views/layout.ecr"
end

get "/registry" do
  pp registry
  render "views/registry.ecr", "views/layout.ecr"
end

post "/room" do |env|
  # create a new room object
  # add the room in the registry
  name = env.params.body["name"]
  newroom = Anyquestion::Room.new(name)
  registry.add newroom
  pp newroom
  pp registry
  # registry.add newroom
  render "views/room.ecr"
end

get "/room/:id" do |env|
  id = env.params.url["id"].to_i
  pp id
  pp registry.rooms
  if registry.rooms[id]?
    room = registry.rooms[id]
    pp room
    render "views/room.ecr"
  else
    flash = "Unknown room"
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
  render "views/404.ecr", "views/layout.ecr"
end

Kemal.run
