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
          syntax: self.class.syntax,
          load_paths: input[:environment].paths,
          importer: SassC::Rails::Importer,
          style: sass_style,
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
          syntax: syntax,
          load_paths: context.environment.paths,
          importer: SassC::Rails::Importer,
          style: sass_style,
          sprockets: {
            context: context,
            environment: context.environment
          }
        }

        ::SassC::Engine.new(data, options).render
      end
    end

    if Sprockets::VERSION > "3.0.0"
      include Sprockets3
    else
      include Sprockets2
    end

    def sass_style
      style = Rails.application.config.sass.style || :expanded
      "sass_style_#{style}".to_sym
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
