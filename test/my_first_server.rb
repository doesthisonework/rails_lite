require 'webrick'

server = WEBrick::HTTPServer.new Port: 8080

server.mount_proc('/') do |request, response|
  response.content_type = 'text/text'
  response.body = "The current time is: #{Time.now}"
end

trap('INT') { server.shutdown }
server.start
