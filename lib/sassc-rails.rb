begin
  require "sass-rails"
  Rails::Railtie.subclasses.delete Sass::Rails::Railtie
rescue LoadError
end

require_relative "sassc/rails"

