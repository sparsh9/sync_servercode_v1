require "test_helper"

class SyncControllerTest < ActionDispatch::IntegrationTest
  test "should get sync_data" do
    get sync_sync_data_url
    assert_response :success
  end
end
