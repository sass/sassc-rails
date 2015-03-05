require File.expand_path('../boot', __FILE__)

[
  "action_controller",
  "action_view",
  "rails/test_unit",
  "sprockets",
  # "active_record",
  # "action_mailer",
  # "active_job"
].each do |framework|
  begin
    require "#{framework}/railtie"
  rescue LoadError
  end
end

Bundler.require(*Rails.groups)
require "sassc-rails"

module Dummy
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    config.secret_key_base = "test"

    # Also turned cache_classes to FALSE to disable caching
    config.assets.configure do |env|
      env.cache = ActiveSupport::Cache::NullStore
    end
  end
end
