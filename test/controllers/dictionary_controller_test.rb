require "test_helper"

class DictionaryControllerTest < ActionDispatch::IntegrationTest
  test "should get top" do
    get dictionary_top_url
    assert_response :success
  end
end
