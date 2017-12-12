require_relative 'boot'

require 'rails/all'
require 'wicked_pdf'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Contestr
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # The code opens the config/local_env.yml file, reads each key/value
    # pair, and sets environment variables.
    # http://railsapps.github.io/rails-environment-variables.html
    config.before_configuration do
      env_file = File.join(Rails.root, 'config', 'local_env.yml')
      YAML.load(File.open(env_file)).each do |key, value|
        ENV[key.to_s] = value
      end if File.exists?(env_file)
    end

    config.active_record.default_timezone = :local
    config.middleware.use WickedPdf::Middleware
  end
end
