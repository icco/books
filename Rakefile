require "sinatra/activerecord/rake"
require "./app"

desc "Just for shits."
task :work do
  BookGrabber.to_read(12680)
end

desc 'Generate a cryptographically secure secret key (this is typically used to generate a secret for cookie sessions).'
task :secret do
  require 'securerandom'
  puts SecureRandom.hex(64)
end
