require 'sprockets/sass_compressor'

class Sprockets::SassCompressor
  def call(*args)
    input = if defined?(data)
      data # sprockets 2.x
    else
      args[0][:data] #sprockets 3.x
    end

    SassC::Engine.new(
      input,
      {
        style: :compressed
      }
    ).render
  end

  # sprockets 2.x
  alias :evaluate :call
end
