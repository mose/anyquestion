require "kemal"
require "./anyquestion/*"

config = Anyquestion::Configuration.load
registry = Anyquestion::Registry.new
sessions = Anyquestion::Sessions.new(config)

public_folder config.public_folder

macro in_layout(tpl)
  render "views/#{{{tpl}}}.ecr", "views/layout.ecr"
end

get "/" do |env|
  logged = sessions.check?(env, "logged")
  in_layout "home"
end

get "/help" do
  logged = sessions.check?(env, "logged")
  in_layout "help"
end

post "/room" do |env|
  logged = sessions.check?(env, "logged")
  name = env.params.body["name"]
  room = Anyquestion::Room.new(name)
  registry.add room
  env.redirect "/room/#{room.id}"
end

get "/room/:id" do |env|
  logged = sessions.check?(env, "logged")
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

get "/clean" do |env|
  logged = sessions.check?(env, "logged")
  in_layout "clean"
end

get "/login" do |env|
  logged = sessions.check?(env, "logged")
  msg = env.params.query["msg"]
  in_layout "login"
end

post "/login" do |env|
  logged = sessions.check?(env, "logged")
  if config.password == env.params.query["password"]
    sessions.set(env, "logged")
  else
    env.redirect "/login"
  end
end

get "/logout" do |env|
  logged = sessions.check?(env, "logged")
  env.session.int("logged", false)
  env.redirect "/"
end

error 404 do
  in_layout "404"
end

Kemal.run
