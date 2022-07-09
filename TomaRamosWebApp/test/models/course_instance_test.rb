require "test_helper"

class CourseInstanceTest < ActiveSupport::TestCase
  test "insert success" do
    testCourse = getFooCourseInstance(title: "Cálculo II")
    assert(testCourse.save())
  end
end
