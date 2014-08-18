require 'test_helper'

class LazyDataApiTest < ActiveSupport::TestCase
  test "should_be_apiable" do
      Page.lazy_data

      assert Page.apiable?
    end

    test "should_have_api_id" do
      Page.lazy_data

      @page = Page.new
      assert_respond_to @page, :api_id
    end
end
