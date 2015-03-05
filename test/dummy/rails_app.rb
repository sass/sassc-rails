# config
DummyApp = Class.new(Rails::Application)
DummyApp.config.cache_classes = false
DummyApp.config.active_support.deprecation = :log
DummyApp.config.eager_load = false

DummyApp.config.root = File.dirname(__FILE__)
Rails.backtrace_cleaner.remove_silencers!
DummyApp.initialize!
