require "test_helper"
require "date"
require "enums/day_of_week_enum"

class CourseEventTest < ActiveSupport::TestCase
  setup do
    count = CourseEvent.count()
    raise RuntimeError.new(
      "CourseEvent table is not empty (#{count})"
    ) unless (count == 0)
  end

  # test "CLASS insert success" do
  #   raise NotImplementedError.new("course and type references")

  #   testClassEvent = CourseEvent.new(
  #     location: "B-35",
  #     day_of_week: DayOfWeekEnum::FRIDAY,
  #     start_time: "10:30",
  #     end_time: "12:20"
  #     #// date: Date.new(2077, 2, 22)
  #   )
  #   assert_equal(true, testClassEvent.save())
  #   #TODO: CourseInstance REF
  #   #TODO: EventType REF
  # end
end
