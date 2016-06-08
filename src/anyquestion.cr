require "kemal"

require "./anyquestion/*"

get "/" do
  "Hello World!"
end

Kemal.run
