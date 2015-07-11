require 'sprockets/sass_compressor'

class Sprockets::SassCompressor
  def call(*args)
    input = if defined?(data)
      data
    else
      args[0][:data]
    end

    SassC::Engine.new(
      input,
      {
        style: :compressed
      }
    ).render
  end
  alias :evaluate :call
end
