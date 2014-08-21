require 'test_helper'

class LazyDataApiTest < ActiveSupport::TestCase
  fixtures :lazy_dummies

  test "should not be apiable by default" do
    assert !NoLazyDummy.apiable?
  end

  test "should be apiable" do
    assert LazyDummy.apiable?
  end

  test "should have api_id" do
    dummy = lazy_dummies(:lazy_dummy)
    assert_respond_to dummy, :api_id
  end

  test "should have default api_id" do
    dummy = lazy_dummies(:lazy_dummy)
    assert_not_nil dummy.api_id
  end

  test "should find api_id" do
    dummy = lazy_dummies(:lazy_dummy)
    dummy.save
    assert_equal dummy, LazyDummy.find_for_api(dummy.class.name, dummy.api_id)
  end
end
