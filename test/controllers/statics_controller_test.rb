require 'test_helper'

class StaticsControllerTest < ActionDispatch::IntegrationTest
  test "should get top" do
    get statics_top_url
    assert_response :success
  end

end
