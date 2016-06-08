require "kemal"
require "./anyquestion/*"

$register = Anyquestion::Register.new

get "/" do |env|
  render "views/home.ecr", "views/layout.ecr"
end

get "/register" do
  render "views/register.ecr", "views/layout.ecr"
end

Kemal.run
