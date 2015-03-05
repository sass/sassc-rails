require "sprockets/sass_template"
require "sassc"

module Sprockets
  class SassTemplate
    module Functions
      def asset_data_url(path)
        SassC::Script::String.new("url(" + sprockets_context.asset_data_uri(path.value) + ")")
      end
    end
  end
end
