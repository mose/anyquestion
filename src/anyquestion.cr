require "kemal"
require "uri"
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

get "/help" do |env|
  logged = sessions.check?(env, "logged")
  in_layout "help"
end

post "/room" do |env|
  logged = sessions.check?(env, "logged")
  if config.anon_create != "false" || logged
    name = env.params.body["name"]
    room = Anyquestion::Room.new(HTML.escape name)
    registry.add room
    env.redirect "/room/#{room.id}"
  else
    env.redirect "/"
  end
end

get "/room/:id" do |env|
  logged = sessions.check?(env, "logged")
  begin
    id = env.params.url["id"]
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
    id = env.params.query["room"]
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
  if logged
    in_layout "clean"
  else
    env.redirect "/"
  end
end

get "/login" do |env|
  logged = sessions.check?(env, "logged")
  in_layout "login"
end

post "/login" do |env|
  logged = sessions.check?(env, "logged")
  if config.password == env.params.body["password"]
    sessions.set(env, "logged")
    env.redirect "/"
  else
    env.redirect "/login"
  end
end

get "/logout" do |env|
  sessions.drop(env)
  logged = sessions.check?(env, "logged")
  env.redirect "/"
end

get "/question/:rid/:qid/delete" do |env|
  logged = sessions.check?(env, "logged")
  if logged
    rid = env.params.url["rid"]
    if registry.rooms[rid]?
      room = registry.rooms[rid]
      qid = env.params.url["qid"]
      room.questions.delete qid
    end
    env.redirect "/clean"
  else
    env.redirect "/"
  end
end

get "/room/:id/delete" do |env|
  logged = sessions.check?(env, "logged")
  if logged
    id = env.params.url["id"]
    if registry.rooms[id]?
      room = registry.rooms[id]
      registry.rooms.delete id
    end
    env.redirect "/clean"
  else
    env.redirect "/"
  end
end

get "/export" do |env|
  logged = sessions.check?(env, "logged")
  if logged
    export = {"payload": registry}.to_json
    in_layout "export"
  else
    env.redirect "/"
  end
end

get "/import" do |env|
  logged = sessions.check?(env, "logged")
  if logged
    in_layout "import"
  else
    env.redirect "/"
  end
end

post "/import" do |env|
  logged = sessions.check?(env, "logged")
  if logged
    registry = Anyquestion::Registry.from_json env.params.body["meat"], root: "payload"
    env.redirect "/"
  else
    env.redirect "/"
  end
end

error 404 do |env|
  logged = sessions.check?(env, "logged")
  in_layout "404"
end

Kemal.run
