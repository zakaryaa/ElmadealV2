require 'test_helper'

class BackofficeControllerTest < ActionDispatch::IntegrationTest
  test "should get dashboard" do
    get backoffice_dashboard_url
    assert_response :success
  end

end
