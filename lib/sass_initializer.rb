module SassInitializer
  def self.registered(app)
    # Enables support for SASS template reloading in rack applications.
    # See http://nex-3.com/posts/88-sass-supports-rack for more details.
    require 'sass/plugin/rack'
    Sass::Plugin.options[:always_update]     = (app.settings.environment == :development)
    Sass::Plugin.options[:css_location]      = "public/css"
    Sass::Plugin.options[:full_exception]    = (app.settings.environment == :development)
    Sass::Plugin.options[:never_update]      = (app.settings.environment == :production)
    Sass::Plugin.options[:style]             = :compact
    Sass::Plugin.options[:template_location] = "scss"
    app.use Sass::Plugin::Rack
  end
end
