require_relative 'boot'

# require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_record/railtie"
# require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "sprockets/railtie"
require "active_record/typed_store/identity_coder"
require_relative '../lib/cloudflare_proxy'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ControleDePonto
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    config.middleware.use Rack::Deflater
    config.middleware.use CloudflareProxy

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
    config.time_zone = 'UTC'
    config.i18n.default_locale = :'pt-BR'
  end
end
