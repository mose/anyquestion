require "kemal"
require "./anyquestion/*"

registry = Anyquestion::Registry.new

messages = [] of String
sockets = [] of HTTP::WebSocket

get "/" do |env|
  render "views/home.ecr", "views/layout.ecr"
end

get "/registry" do
  render "views/registry.ecr", "views/layout.ecr"
end

post "/room" do |env|
  # create a new room object
  # add the room in the registry
  name = env.params.body["name"]
  registry.add Anyquestion::Room.new(name)
  render "views/room.ecr"
end

get "/room" do |env|
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

Kemal.run
