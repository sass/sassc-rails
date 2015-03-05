require "test_helper"

class SassRailsTest < MiniTest::Test
  def render_asset(asset)
    app.assets[asset].to_s
  end

  attr_reader :app

  def setup
    @app = Class.new(Rails::Application)
    @app.config.active_support.deprecation = :log
    @app.config.eager_load = false

    @app.config.root = File.join(File.dirname(__FILE__), "dummy")
    @app.config.active_support.test_order = :sorted

    Rails.backtrace_cleaner.remove_silencers!
    @app.initialize!
  end

  def teardown
    FileUtils.remove_dir "#{Rails.root}/tmp"
  end

  def test_setup_works
    asset = render_asset("application.scss")

    assert_equal <<-CSS, asset
.hello {
  color: #FFF; }
    CSS
  end

  def test_raises_sassc_syntax_error
    assert_raises(SassC::SyntaxError) do
      render_asset("syntax_error.scss")
    end
  end

  def test_all_sass_asset_paths_work
    css_output = render_asset("helpers_test.scss")

    skip

    assert_match %r{asset-path:\s*"/assets/rails.png"},                           css_output, 'asset-path:\s*"/assets/rails.png"'
    assert_match %r{asset-url:\s*url\(/assets/rails.png\)},                       css_output, 'asset-url:\s*url\(/assets/rails.png\)'
    assert_match %r{image-path:\s*"/assets/rails.png"},                           css_output, 'image-path:\s*"/assets/rails.png"'
    assert_match %r{image-url:\s*url\(/assets/rails.png\)},                       css_output, 'image-url:\s*url\(/assets/rails.png\)'
  end

  def test_sass_asset_paths_work
    css_output = render_asset("helpers_test.scss")

    assert_match %r{video-path:\s*"/videos/rails.mp4"},                           css_output, 'video-path:\s*"/videos/rails.mp4"'
    assert_match %r{video-url:\s*url\(/videos/rails.mp4\)},                       css_output, 'video-url:\s*url\(/videos/rails.mp4\)'
    assert_match %r{audio-path:\s*"/audios/rails.mp3"},                           css_output, 'audio-path:\s*"/audios/rails.mp3"'
    assert_match %r{audio-url:\s*url\(/audios/rails.mp3\)},                       css_output, 'audio-url:\s*url\(/audios/rails.mp3\)'
    assert_match %r{font-path:\s*"/fonts/rails.ttf"},                             css_output, 'font-path:\s*"/fonts/rails.ttf"'
    assert_match %r{font-url:\s*url\(/fonts/rails.ttf\)},                         css_output, 'font-url:\s*url\(/fonts/rails.ttf\)'
    assert_match %r{font-url-with-query-hash:\s*url\(/fonts/rails.ttf\?#iefix\)}, css_output, 'font-url:\s*url\(/fonts/rails.ttf?#iefix\)'
    assert_match %r{javascript-path:\s*"/javascripts/rails.js"},                  css_output, 'javascript-path:\s*"/javascripts/rails.js"'
    assert_match %r{javascript-url:\s*url\(/javascripts/rails.js\)},              css_output, 'javascript-url:\s*url\(/javascripts/rails.js\)'
    assert_match %r{stylesheet-path:\s*"/stylesheets/rails.css"},                 css_output, 'stylesheet-path:\s*"/stylesheets/rails.css"'
    assert_match %r{stylesheet-url:\s*url\(/stylesheets/rails.css\)},             css_output, 'stylesheet-url:\s*url\(/stylesheets/rails.css\)'

    asset_data_url_regexp = %r{asset-data-url:\s*url\((.*?)\)}
    assert_match asset_data_url_regexp, css_output, 'asset-data-url:\s*url\((.*?)\)'
    asset_data_url_match = css_output.match(asset_data_url_regexp)[1]
    asset_data_url_expected = "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAyRpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw%" +
    "2FeHBhY2tldCBiZWdpbj0i77u%2FIiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8%2BIDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuMC1jMDYxIDY0LjE0MDk0OSwgMjA" +
    "xMC8xMi8wNy0xMDo1NzowMSAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wPSJodHRw" +
    "Oi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvIiB4bWxuczp4bXBNTT0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wL21tLyIgeG1sbnM6c3RSZWY9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9zVHlwZS9SZXNvdXJjZVJlZiMiIHhtcDpDc" +
    "mVhdG9yVG9vbD0iQWRvYmUgUGhvdG9zaG9wIENTNS4xIE1hY2ludG9zaCIgeG1wTU06SW5zdGFuY2VJRD0ieG1wLmlpZDpCNzY5NDE1QkQ2NkMxMUUwOUUzM0E5Q0E2RTgyQUExQiIgeG1wTU06RG9jdW1lbnRJRD0ieG1wLmRpZDpCNzY5NDE1Q0" +
    "Q2NkMxMUUwOUUzM0E5Q0E2RTgyQUExQiI%2BIDx4bXBNTTpEZXJpdmVkRnJvbSBzdFJlZjppbnN0YW5jZUlEPSJ4bXAuaWlkOkE3MzcyNTQ2RDY2QjExRTA5RTMzQTlDQTZFODJBQTFCIiBzdFJlZjpkb2N1bWVudElEPSJ4bXAuZGlkOkI3Njk0M" +
    "TVBRDY2QzExRTA5RTMzQTlDQTZFODJBQTFCIi8%2BIDwvcmRmOkRlc2NyaXB0aW9uPiA8L3JkZjpSREY%2BIDwveDp4bXBtZXRhPiA8P3hwYWNrZXQgZW5kPSJyIj8%2B0HhJ9AAAABBJREFUeNpi%2BP%2F%2FPwNAgAEACPwC%2FtuiTRYAAAAA" +
    "SUVORK5CYII%3D"
    assert_equal asset_data_url_expected, asset_data_url_match
  end
end
