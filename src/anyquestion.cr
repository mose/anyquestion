require "kemal"
require "./anyquestion/*"

config = Anyquestion::Configuration.load
registry = Anyquestion::Registry.new
sessions = Anyquestion::Sessions.new(config)

public_folder config.public_folder

macro in_layout(tpl)
  render "views/#{{{tpl}}}.ecr", "views/layout.ecr"
end

macro init_auth
  logged = sessions.check?(env, "logged")
end

get "/" do |env|
  init_auth
  puts config.anon_create
  in_layout "home"
end

get "/help" do |env|
  init_auth
  in_layout "help"
end

post "/room" do |env|
  init_auth
  if config.anon_create || logged
    name = env.params.body["name"]
    room = Anyquestion::Room.new(name)
    registry.add room
    env.redirect "/room/#{room.id}"
  else
    env.redirect "/"
  end
end

get "/room/:id" do |env|
  init_auth
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
  init_auth
  if logged
    in_layout "clean"
  else
    env.redirect "/"
  end
end

get "/login" do |env|
  init_auth
  in_layout "login"
end

post "/login" do |env|
  init_auth
  if config.password == env.params.body["password"]
    sessions.set(env, "logged")
    env.redirect "/"
  else
    env.redirect "/login"
  end
end

get "/logout" do |env|
  sessions.drop(env)
  init_auth
  env.redirect "/"
end

error 404 do |env|
  init_auth
  in_layout "404"
end

Kemal.run
