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
    if connections[settings.environment]
      url = URI(connections[settings.environment])
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

      #logger.devel "DB: #{options.inspect}"
      set :database, options
    else
      #logger.fatal "No database configuration for #{settings.environment.inspect}"
    end
  end

  get "/" do
    @genres = Genre.where("name like '%graphic%'")
    @books = Book.where("pub_date < ?", Time.now).where(shelf: "to-read").to_a
    @books = @books.delete_if {|book| book.genres.where(id: @genres).empty? }
    erb :index
  end

  get "/config" do
    settings.database.inspect
  end
end
