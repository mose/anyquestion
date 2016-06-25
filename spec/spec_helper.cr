require "spec"
require "http"

def http_request(method, endpoint)
  request = HTTP::Request.new(method, endpoint)
  io = MemoryIO.new
  response = HTTP::Server::Response.new(io)
  context = HTTP::Server::Context.new(request, response)
  Kemal::RouteHandler::INSTANCE.call(context)
  response.close
  io.rewind
  HTTP::Client::Response.from_io(io, decompress: false)
end
