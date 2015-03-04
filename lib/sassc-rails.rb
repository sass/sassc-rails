begin
  require "sass-rails"
  Sass::Rails.send(:remove_const, :Railtie)
rescue LoadError
end

require_relative "sassc/rails"

