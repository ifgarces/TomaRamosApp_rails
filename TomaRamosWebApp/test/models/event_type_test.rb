require "test_helper"
require "enums/event_type_enum"

class EventTypeTest < ActiveSupport::TestCase
  test "insert success" do
    testCourse = EventType.new(name: EventTypeEnum::CLASS)
    assert(testCourse.save())
  end

  # test "insert validation error" do
  #   raise NotImplementedError.new()
  #   testCourse = EventType.new(name: "WHATEVER")
  #   #TODO: check for valid names, add database validation for this model
  # end
end
