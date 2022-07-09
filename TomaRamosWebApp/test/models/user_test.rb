require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "insert success" do
    testUser = getFooUser()
    assert(testUser.save())
    assert_not_nil(testUser.last_activity)
  end

  test "createNewGuestUser success" do
    assert_equal(0, User.count())
    User.createNewGuestUser()
    assert_equal(1, User.count())
  end

  test "isGuestUser true" do
    guest = User.createNewGuestUser()
    assert(guest.isGuestUser())
  end

  test "isGuestUser false" do
    guest = getFooUser()
    assert_not(guest.isGuestUser())
  end

  test "inscribeNewCourse" do
    guest = User.createNewGuestUser()

    fooCourse = getFooCourseInstance(title: "abcabc")
    guest.inscribeNewCourse(fooCourse)

    expected = [fooCourse]
    got = guest.getInscribedCourses()

    assert_equal(expected, got)
  end
end
