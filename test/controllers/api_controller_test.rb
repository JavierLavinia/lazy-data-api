require 'test_helper'

class LazyDataApi::ApiControllerTest < ActionController::TestCase
  test "should get show" do
    dummy = create :lazy_dummy
    get :show, resource_name: :lazy_dummy, api_id: dummy.api_id

    assert_response :success
    assert_not_nil assigns(:resource)
    assert_equal assigns(:resource), dummy
  end

  test "should get error with worng api id lazy model" do
    dummy = create :lazy_dummy
    get :show, resource_name: :lazy_dummy, api_id: dummy.api_id.reverse

    assert_response :not_found
    assert !assigns(:resource)
  end

  test "should get error with no lazy model" do
    get :show, resource_name: :no_lazy_dummy, api_id: ''

    assert_response :not_found
    assert !assigns(:resource)
  end
end
