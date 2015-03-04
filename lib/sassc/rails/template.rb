require 'sassc'

#require 'rack/utils'
#require 'sassc'
#require 'uri'

require "sprockets/sass_template"
require "sprockets/utils"

#require 'sass/rails/cache_store'
#require 'sass/rails/helpers'
#require 'sprockets/sass_functions'
#require 'tilt'

module SassC::Rails
  class SassTemplate < Sprockets::SassTemplate
    def call(input)
      context = input[:environment].context_class.new(input)

      options = {
        filename: input[:filename],
        syntax: self.class.syntax,
        #cache_store: CacheStore.new(input[:cache], @cache_version),
        load_paths: input[:environment].paths,
        sprockets: {
          context: context,
          environment: input[:environment],
          dependencies: context.metadata[:dependency_paths]
        }
      }

      engine = ::SassC::Engine.new(input[:data], options)

      css = Sprockets::Utils.module_include(::SassC::Script::Functions, @functions) do
        engine.render
      end

      # Track all imported files
      engine.dependencies.map do |dependency|
        context.metadata[:dependency_paths] << dependency.options[:filename]
      end

      context.metadata.merge(data: css)
    end

    module Functions
      def asset_path(path, options = {})
        path = path.value

        path, _, query, fragment = URI.split(path)[5..8]
        path     = sprockets_context.asset_path(path, options)
        query    = "?#{query}" if query
        fragment = "##{fragment}" if fragment

        ::SassC::Script::String.new("#{path}#{query}#{fragment}", :string)
      end

      def asset_url(path, options = {})
        ::SassC::Script::String.new("url(#{asset_path(path, options).value})")
      end

      def asset_data_url(path)
        if asset = sprockets_environment.find_asset(path.value, accept_encoding: 'base64')
          sprockets_dependencies << asset.filename
          url = "data:#{asset.content_type};base64,#{Rack::Utils.escape(asset.to_s)}"
          ::SassC::Script::String.new("url(" + url + ")")
        end
      end
    end
  end
end


# module Sass
#   module Rails
#     class SassTemplate < Tilt::Template
#       def self.default_mime_type
#         'text/css'
#       end
# 
#       def self.engine_initialized?
#         true
#       end
# 
#       def initialize_engine
#       end
# 
#       def prepare
#       end
# 
#       def syntax
#         :sass
#       end
# 
#       def evaluate(context, locals, &block)
#         cache_store = CacheStore.new(context.environment)
# 
#         options = {
#           :filename => eval_file,
#           :line => line,
#           :syntax => syntax,
#           :cache_store => cache_store,
#           :importer => importer_class.new(context.pathname.to_s),
#           :load_paths => context.environment.paths.map { |path| importer_class.new(path.to_s) },
#           :sprockets => {
#             :context => context,
#             :environment => context.environment
#           }
#         }
# 
#         sass_config = context.sass_config.merge(options)
# 
#         engine = ::Sass::Engine.new(data, sass_config)
#         css = engine.render
# 
#         engine.dependencies.map do |dependency|
#           context.depend_on(dependency.options[:filename])
#         end
# 
#         css
#       rescue ::Sass::SyntaxError => e
#         context.__LINE__ = e.sass_backtrace.first[:line]
#         raise e
#       end
# 
#       private
# 
#       def importer_class
#         SassImporter
#       end
#     end
# 
#     class ScssTemplate < SassTemplate
#       def syntax
#         :scss
#       end
#     end
#   end
# end
