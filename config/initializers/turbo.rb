# config/initializers/turbo.rb
# This registers the .turbo_stream format so the controller doesn't crash
Mime::Type.register "text/vnd.turbo-stream.html", :turbo_stream
