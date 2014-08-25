require 'test_helper'

class LazyDataApi::ApiControllerTest < ActionController::TestCase
  test "should success show" do
    dummy = create :lazy_dummy
    get :show, resource_name: :lazy_dummy, api_id: dummy.api_id

    assert_response :success
  end

  test "should have resorce when show" do
    dummy = create :lazy_dummy
    get :show, resource_name: :lazy_dummy, api_id: dummy.api_id

    assert_not_nil assigns(:resource)
  end

  test "should have right resorce when show" do
    dummy = create :lazy_dummy
    get :show, resource_name: :lazy_dummy, api_id: dummy.api_id

    assert_equal assigns(:resource), dummy
  end

  test "should have resorce json when show" do
    dummy = create :lazy_dummy
    get :show, resource_name: :lazy_dummy, api_id: dummy.api_id

    assert_equal @response.body, dummy.to_api.to_json
  end

  test "should respond not found with no lazy model when show" do
    get :show, resource_name: :no_lazy_dummy, api_id: ''

    assert_response :not_found
  end

  test "should not get resource with no lazy model when show" do
    get :show, resource_name: :no_lazy_dummy, api_id: ''

    assert !assigns(:resource)
  end

  test "should create the resource" do
    dummy = build :lazy_dummy
    LazyDataApi::ApiController.any_instance.stubs(:get_resource_data).returns(dummy.to_api)
    post :create, resource_name: :lazy_dummy, api_id: dummy.api_id

    assert_response :success
    assert_not_nil LazyDummy.find_for_api(dummy.api_id)
  end
end
