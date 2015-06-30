require "sprockets/version"
require "sprockets/sass_template"
require "sprockets/utils"

module SassC::Rails
  class SassTemplate < Sprockets::SassTemplate
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
        }.merge(config_options)

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
        }.merge(config_options)

        ::SassC::Engine.new(data, options).render
      end
    end

    if Sprockets::VERSION > "3.0.0"
      include Sprockets3
    else
      include Sprockets2
    end

    def config_options
      opts = { style: sass_style }


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

    def line_comments?
      Rails.application.config.sass.line_comments
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
