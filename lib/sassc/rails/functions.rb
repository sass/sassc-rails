# frozen_string_literal: true

begin
  require 'sprockets/sassc_processor'
  mod = Sprockets::SasscProcessor::Functions
rescue LoadError
  require 'sprockets/sass_functions'
  mod = Sprockets::SassFunctions
end

mod.instance_eval do
  def asset_data_url(path)
    ::SassC::Script::Value::String.new("url(" + sprockets_context.asset_data_uri(path.value) + ")")
  end
end

::SassC::Script::Functions.send :include, mod
