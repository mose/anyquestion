require "kemal"
require "./anyquestion/*"

Anyquestion::Config.load("development")

registry = Anyquestion::Registry.new

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
  env.redirect "/room/#{room.id}"
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

ws "/ws" do |socket, env|
  begin
    id = env.params.query["room"].to_i
    if registry.rooms[id]?
      room = registry.rooms[id]
      room.handle socket
    else
      env.response.status_code = 404
    end
  rescue
    env.response.status_code = 404
  end
end

error 404 do
  in_layout "404"
end

Kemal.run
