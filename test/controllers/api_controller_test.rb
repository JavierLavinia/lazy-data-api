require 'test_helper'
require 'fakeweb'

class LazyDataApi::ApiControllerTest < ActionController::TestCase
  test "should success show" do
    dummy = create :lazy_dummy
    get :show, resource_name: :lazy_dummy, api_id: dummy.api_id, use_route: :lazy_data_api

    assert_response :success
  end

  test "should have resorce when show" do
    dummy = create :lazy_dummy
    get :show, resource_name: :lazy_dummy, api_id: dummy.api_id, use_route: :lazy_data_api

    assert_not_nil assigns(:resource)
  end

  test "should have right resorce when show" do
    dummy = create :lazy_dummy
    get :show, resource_name: :lazy_dummy, api_id: dummy.api_id, use_route: :lazy_data_api

    assert_equal assigns(:resource), dummy
  end

  test "should have resorce json when show" do
    dummy = create :lazy_dummy
    get :show, resource_name: :lazy_dummy, api_id: dummy.api_id, use_route: :lazy_data_api

    assert_equal @response.body, dummy.to_api.to_json
  end

  test "should respond not found with no lazy model when show" do
    get :show, resource_name: :no_lazy_dummy, api_id: '', use_route: :lazy_data_api

    assert_response :not_found
  end

  test "should not get resource with no lazy model when show" do
    get :show, resource_name: :no_lazy_dummy, api_id: '', use_route: :lazy_data_api

    assert !assigns(:resource)
  end

  test "should create the resource" do
    dummy = build :lazy_dummy
    ActionDispatch::Request.any_instance.stubs(:referer).returns('http://host.test')
    request_params = dummy.to_api.merge resource_name: :lazy_dummy, api_id: dummy.api_id, use_route: :lazy_data_api
    post :create, request_params

    assert_response :success
    assert_not_nil LazyDummy.find_for_api(dummy.api_id)
  end

  test "should not create the duplicated resource" do
    dummy = create :lazy_dummy
    ActionDispatch::Request.any_instance.stubs(:referer).returns('http://host.test')
    request_params = dummy.to_api.merge resource_name: :lazy_dummy, api_id: dummy.api_id, use_route: :lazy_data_api
    post :create, request_params

    assert_response :not_found
    assert_equal LazyDataApi::Relation.where(api_id: dummy.api_id, apiable_type: dummy.class).count, 1
  end

  test "should update the resource" do
    dummy = create :lazy_dummy
    ActionDispatch::Request.any_instance.stubs(:referer).returns('http://host.test')
    initial_value = dummy.integer
    updated_value = dummy.integer += 1
    request_params = dummy.to_api.merge resource_name: :lazy_dummy, api_id: dummy.api_id, use_route: :lazy_data_api
    put :update, request_params

    assert_response :success

    updated_dummy = LazyDummy.find_for_api(dummy.api_id)
    assert_equal updated_dummy.integer, updated_value
    assert_not_equal updated_dummy.integer, initial_value
  end

  test "should get error on forward unknow action" do
    dummy = create :lazy_dummy
    ActionDispatch::Request.any_instance.stubs(:referer).returns('http://host.test')
    get :forward, resource_name: :lazy_dummy, api_id: dummy.api_id, use_route: :lazy_data_api, server_name: :test, forward_action: :test

    assert_response :error
  end

  test "should get not found on forward unknow server" do
    dummy = create :lazy_dummy
    ActionDispatch::Request.any_instance.stubs(:referer).returns('http://host.test')
    get :forward, resource_name: :lazy_dummy, api_id: dummy.api_id, use_route: :lazy_data_api, server_name: :fake_server, forward_action: :test

    assert_response :not_found
  end

  test "should POST data on forward create action" do
    dummy = create :lazy_dummy
    ActionDispatch::Request.any_instance.stubs(:referer).returns('http://host.test')
    action_url = LazyDataApi::Engine.routes.url_helpers.create_resource_url dummy.server_url_options(:test)
    FakeWeb.register_uri(:post, action_url, body: "OK")

    get :forward, resource_name: :lazy_dummy, api_id: dummy.api_id, use_route: :lazy_data_api, server_name: :test, forward_action: :create

    assert_response :success
  end

  test "should PUT data on forward create action" do
    dummy = create :lazy_dummy
    ActionDispatch::Request.any_instance.stubs(:referer).returns('http://host.test')
    action_url = LazyDataApi::Engine.routes.url_helpers.create_resource_url dummy.server_url_options(:test)
    FakeWeb.register_uri(:put, action_url, body: "OK")

    get :forward, resource_name: :lazy_dummy, api_id: dummy.api_id, use_route: :lazy_data_api, server_name: :test, forward_action: :update

    assert_response :success
  end

  test "should get error from server" do
    dummy = create :lazy_dummy
    ActionDispatch::Request.any_instance.stubs(:referer).returns('http://host.test')
    action_url = LazyDataApi::Engine.routes.url_helpers.create_resource_url dummy.server_url_options(:test)
    FakeWeb.register_uri(:post, action_url, status: 500)

    get :forward, resource_name: :lazy_dummy, api_id: dummy.api_id, use_route: :lazy_data_api, server_name: :test, forward_action: :create

    assert_response :error
  end

  test "should get not found from server" do
    dummy = create :lazy_dummy
    ActionDispatch::Request.any_instance.stubs(:referer).returns('http://host.test')
    action_url = LazyDataApi::Engine.routes.url_helpers.create_resource_url dummy.server_url_options(:test)
    FakeWeb.register_uri(:post, action_url, status: 404)

    get :forward, resource_name: :lazy_dummy, api_id: dummy.api_id, use_route: :lazy_data_api, server_name: :test, forward_action: :create

    assert_response :not_found
  end
end
