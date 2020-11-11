require 'test_helper'

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    stub_request(:post, "https://publish.cased.com/").
      to_return(status: 200, body: "", headers: {})

    get root_url

    assert_response :success
  end

end
