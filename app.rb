require "sinatra/base"
require "sinatra/activerecord"

# Require the whole lib/ folder.
Dir[File.dirname(__FILE__) + '/lib/*.rb'].each {|file| require file }

class Books < Sinatra::Base
  register Sinatra::ActiveRecordExtension
  register SassInitializer

  configure do
    # Common Configs
    set :logging, true
    set :sessions, true
    set :session_secret, ENV['SESSION_SECRET'] || 'blargh'

    use ActiveRecord::QueryCache

    ActiveRecord::Base.logger = ActiveSupport::Logger.new(STDOUT)
    if !settings.environment.eql? :production
      ActiveRecord::Base.logger.level = 0
    end

    # Database configuration
    connections = {
      :development => "postgres://localhost/books",
      :test => "postgres://postgres@localhost/books_test",
      :production => ENV["DATABASE_URL"]
    }

    active_record = {}
    connections.delete_if {|k,v| !k or !v }.each_pair do |k, v|
      url = URI(v)
      options = {
        :adapter => url.scheme,
        :host => url.host,
        :port => url.port,
        :database => url.path[1..-1],
        :username => url.user,
        :password => url.password
      }

      # Special cases for active record.
      case url.scheme
      when "sqlite"
        options[:adapter] = "sqlite3"
        options[:database] = url.host + url.path
      when "postgres"
        options[:adapter] = "postgresql"
      end

      active_record[k] = options
    end

    set :database, active_record
  end

  get "/" do
    @genres = Genre.where("name LIKE '%comic%' OR name LIKE '%graphic%'")
    @books = Book.where("pub_date < ?", Time.now).where(shelf: "to-read").to_a
    @books = @books.delete_if {|book| book.genres.where(id: @genres).empty? }

    erb :index
  end

  get "/config" do
    settings.database.inspect
  end
end
