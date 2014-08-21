require 'test_helper'

class LazyDataApi::ApiControllerTest < ActionController::TestCase
  fixtures :lazy_dummies

  test "should get show" do
    dummy = lazy_dummies(:lazy_dummy)
    dummy.api_id = 'api_id'
    dummy.save

    get :show, resource_name: :lazy_dummy, api_id: 'api_id'

    assert_response :success
    assert_not_nil assigns(:resource)
    assert_equal assigns(:resource), lazy_dummies(:lazy_dummy)
  end
end
