require 'sassc'
require "sprockets/sass_template"
require "sprockets/utils"

module SassC::Rails
  class SassTemplate < Sprockets::SassTemplate
    def call(input)
      context = input[:environment].context_class.new(input)

      options = {
        filename: input[:filename],
        syntax: self.class.syntax,
        load_paths: input[:environment].paths,
        importer: SassC::Rails::Importer,
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

  class ScssTemplate < SassTemplate
    def self.syntax
      :scss
    end
  end
end
