require 'test_helper'

class LazyDataApi::ApiControllerTest < ActionController::TestCase
  test "should get show" do
    dummy = create :lazy_dummy
    get :show, resource_name: :lazy_dummy, api_id: dummy.api_id

    assert_response :success
    assert_not_nil assigns(:resource)
    assert_equal assigns(:resource), dummy
  end
end
