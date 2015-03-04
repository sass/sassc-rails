require "minitest/autorun"
require "sassc"

SAMPLE_SASS_STRING = "$size: 30px; .hi { width: $size; }"
SAMPLE_CSS_OUTPUT = ".hi {\n  width: 30px; }\n"

class DataContext < MiniTest::Test
  def teardown
    SassC::Native.delete_data_context(@data_context)
  end

  def test_compiled_css_is_correct
    @data_context = SassC::Native.make_data_context(SAMPLE_SASS_STRING)
    context = SassC::Native.data_context_get_context(@data_context)
    SassC::Native.compile_data_context(@data_context)

    css = SassC::Native.context_get_output_string(context)
    assert_equal SAMPLE_CSS_OUTPUT, css
  end
end
