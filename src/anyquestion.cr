require "kemal"

require "./anyquestion/*"

get "/" do |env|
  env.redirect "/index.html"
end

Kemal.run
