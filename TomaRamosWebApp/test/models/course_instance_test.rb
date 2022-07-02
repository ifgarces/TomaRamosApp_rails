require "test_helper"

class CourseInstanceTest < ActiveSupport::TestCase
  test "insert success" do
    testCourse = getFooCourseInstance(title: "Cálculo II")
    assert_equal(true, testCourse.save())
  end
end
