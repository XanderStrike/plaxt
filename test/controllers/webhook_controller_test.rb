require 'test_helper'

class WebhookControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get webhook_index_url
    assert_response :success
  end

end
