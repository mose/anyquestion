require "kemal"
require "./anyquestion/*"

$register = Anyquestion::Register.new

messages = [] of String
sockets = [] of HTTP::WebSocket

get "/" do |env|
  render "views/home.ecr", "views/layout.ecr"
end

get "/register" do
  render "views/register.ecr", "views/layout.ecr"
end

ws "/" do |socket|
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
