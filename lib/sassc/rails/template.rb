require "sprockets/version"

begin
  require 'sprockets/sass_processor'
rescue LoadError
  require "sprockets/sass_template"
end

require "sprockets/utils"

module SassC::Rails

  class SassTemplate < defined?(Sprockets::SassProcessor) ? Sprockets::SassProcessor : Sprockets::SassTemplate
    module Sprockets3
      def call(input)
        context = input[:environment].context_class.new(input)

        options = {
          filename: input[:filename],
          line_comments: line_comments?,
          syntax: self.class.syntax,
          load_paths: input[:environment].paths,
          importer: SassC::Rails::Importer,
          sprockets: {
            context: context,
            environment: input[:environment],
            dependencies: context.metadata[:dependency_paths]
          }
        }.merge(config_options) { |*args| safe_merge(*args) }

        engine = ::SassC::Engine.new(input[:data], options)

        css = Sprockets::Utils.module_include(::SassC::Script::Functions, @functions) do
          engine.render
        end

        context.metadata.merge(data: css)
      end
    end

    module Sprockets2
      def self.included(base)
        base.class_eval do
          self.default_mime_type = "text/css"
        end
      end

      def evaluate(context, locals, &block)
        options = {
          filename: eval_file,
          line_comments: line_comments?,
          syntax: syntax,
          load_paths: context.environment.paths,
          importer: SassC::Rails::Importer,
          sprockets: {
            context: context,
            environment: context.environment
          }
        }.merge(config_options, &method(:safe_merge))

        ::SassC::Engine.new(data, options).render
      end
    end

    if Sprockets::VERSION > "3.0.0"
      include Sprockets3
    else
      include Sprockets2
    end

    def config_options
      opts = { style: sass_style, load_paths: load_paths }


      if Rails.application.config.sass.inline_source_maps
        opts.merge!({
          source_map_file: ".",
          source_map_embed: true,
          source_map_contents: true,
        })
      end

      opts
    end

    def sass_style
      (Rails.application.config.sass.style || :expanded).to_sym
    end

    def load_paths
      Rails.application.config.sass.load_paths || []
    end

    def line_comments?
      Rails.application.config.sass.line_comments
    end

    def safe_merge(key, left, right)
      if [left, right].all? { |v| v.is_a? Hash }
        left.merge(right) { |*args| safe_merge *args }
      elsif [left, right].all? { |v| v.is_a? Array }
        (left + right).uniq
      else
        right
      end
    end
  end

  class ScssTemplate < SassTemplate
    unless Sprockets::VERSION > "3.0.0"
      self.default_mime_type = 'text/css'
    end

    # Sprockets 3
    def self.syntax
      :scss
    end

    # Sprockets 2
    def syntax
      :scss
    end
  end
end
