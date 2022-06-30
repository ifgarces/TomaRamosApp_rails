require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "insert success" do
    testUser = getFooUser()
    assert_equal(true, testUser.save())
    assert_not_nil(testUser.last_activity)
  end

  test "getNewGuestUser" do
    guest = User.getNewGuestUser()
    assert_equal(true, guest.save())
  end

  test "isGuestUser true" do
    guest = User.getNewGuestUser()
    assert_equal(true, guest.isGuestUser())
  end

  test "isGuestUser false" do
    guest = getFooUser()
    assert_equal(false, guest.isGuestUser())
  end
end
