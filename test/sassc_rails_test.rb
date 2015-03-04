require "test_helper"

class SassRailsTest < ActiveSupport::TestCase
  def render_asset(asset)
    Dummy::Application.assets[asset].to_s
  end

  test "test setup works" do
    asset = render_asset("application.scss")

    assert_equal <<-CSS, asset
.hello{color:#FFF}
    CSS
  end

  test "raises SassC syntax error" do
    assert_raises(SassC::SyntaxError) do
      render_asset("syntax_error.scss")
    end
  end

  test "image-url helper" do
    skip "segfault"
    asset = render_asset("helpers_test.scss")
    puts asset
  end
end
