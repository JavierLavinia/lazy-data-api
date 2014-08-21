require 'test_helper'

class LazyDataApiTest < ActiveSupport::TestCase
  test "should not be apiable by default" do
    assert !NoLazyDummy.apiable?
  end

  test "should be apiable" do
    assert LazyDummy.apiable?
  end

  test "should have api_id" do
    dummy = create :lazy_dummy

    assert_respond_to dummy, :api_id
  end

  test "should have default api_id" do
    dummy = create :lazy_dummy

    assert_not_nil dummy.api_id
  end

  test "should find api_id" do
    dummy = create :lazy_dummy

    assert_equal dummy, LazyDummy.find_for_api(dummy.class.name, dummy.api_id)
  end

  test "should keep api_id" do
    dummy = create :lazy_dummy
    initial_api_id = dummy.api_id
    dummy.touch

    assert_equal dummy.api_id, initial_api_id
  end
end
