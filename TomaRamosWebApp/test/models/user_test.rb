require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "insert success" do
    testUser = getFooUser()
    assert_equal(true, testUser.save())
  end
end
