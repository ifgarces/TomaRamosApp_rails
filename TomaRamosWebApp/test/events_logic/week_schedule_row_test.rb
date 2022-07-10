require "test_helper"
require "events_logic/week_schedule_row"
require "enums/day_of_week_enum"

class WeekScheduleRowTest < ActiveSupport::TestCase
  setup do
    @typeClass = EventType.new(name: EventTypeEnum::CLASS)
    @typeAssist = EventType.new(name: EventTypeEnum::ASSISTANTSHIP)
    @typeLab = EventType.new(name: EventTypeEnum::LABORATORY)
    @typeTest = EventType.new(name: EventTypeEnum::TEST)
    @typeExam = EventType.new(name: EventTypeEnum::EXAM)
    [
      @typeClass, @typeAssist, @typeLab, @typeTest, @typeExam
    ].each do |eventType|
      eventType.save!()
    end

    @testPeriod = AcademicPeriod.new(name: "hello-period")
    @testPeriod.save!()
    @testCourseInstance = CourseInstance.new(
      nrc: "123",
      title: "SomeCourse",
      teacher: "John Doe",
      credits: 2,
      career: "ING",
      course_number: 343,
      section: "5",
      curriculum: "PE2022",
      academic_period: @testPeriod
    )
    @testCourseInstance.save!()
  end

  test "addEvent success 01" do
    testEvent = CourseEvent.new(
      event_type: @typeClass,
      location: "B-35",
      day_of_week: DayOfWeekEnum::FRIDAY,
      start_time: Time.utc(2000, 1, 1, 18, 30),
      end_time: Time.utc(2000, 1, 1, 20, 20),
      date: Date.new(2022, 3, 2),
      course_instance: @testCourseInstance
    )
    testEvent.save!() #?

    testScheduleRow = WeekScheduleRow.new()
    testScheduleRow.addEvent(testEvent)
    assert_equal([], testScheduleRow.monday)
    assert_equal([], testScheduleRow.tuesday)
    assert_equal([], testScheduleRow.wednesday)
    assert_equal([], testScheduleRow.thursday)
    assert_equal([testEvent], testScheduleRow.friday)
  end

  test "addEvent success 02" do
    testEvent = CourseEvent.new(
      event_type: @typeClass,
      location: "B-35",
      day_of_week: DayOfWeekEnum::MONDAY,
      start_time: Time.utc(2000, 1, 1, 18, 30),
      end_time: Time.utc(2000, 1, 1, 20, 20),
      date: Date.new(2022, 3, 2),
      course_instance: @testCourseInstance
    )
    testEvent.save!() #?

    testScheduleRow = WeekScheduleRow.new()
    testScheduleRow.addEvent(testEvent)
    assert_equal([testEvent], testScheduleRow.monday)
    assert_equal([], testScheduleRow.tuesday)
    assert_equal([], testScheduleRow.wednesday)
    assert_equal([], testScheduleRow.thursday)
    assert_equal([], testScheduleRow.friday)
  end

  test "addEvent success 03" do
    testEvent01 = CourseEvent.new(
      event_type: @typeClass,
      location: nil,
      day_of_week: DayOfWeekEnum::WEDNESDAY,
      start_time: Time.utc(2000, 1, 1, 18, 30),
      end_time: Time.utc(2000, 1, 1, 20, 20),
      date: Date.new(2022, 3, 2),
      course_instance: @testCourseInstance
    )
    testEvent02 = CourseEvent.new(
      event_type: @typeExam,
      location: "B-35",
      day_of_week: DayOfWeekEnum::MONDAY,
      start_time: Time.utc(2000, 1, 1, 10, 30),
      end_time: Time.utc(2000, 1, 1, 11, 20),
      date: Date.new(2022, 5, 23),
      course_instance: @testCourseInstance
    )
    testEvent01.save!()
    testEvent02.save!()

    testScheduleRow = WeekScheduleRow.new()
    testScheduleRow.addEvent(testEvent01)
    testScheduleRow.addEvent(testEvent02)
    assert_equal([], testScheduleRow.monday)
    assert_equal([], testScheduleRow.tuesday)
    assert_equal([testEvent01], testScheduleRow.wednesday)
    assert_equal([], testScheduleRow.thursday)
    assert_equal([], testScheduleRow.friday)
  end

  test "addEvent success 04" do
    testEvents = [
      CourseEvent.new(
        event_type: @typeAssist,
        location: nil,
        day_of_week: DayOfWeekEnum::WEDNESDAY,
        start_time: Time.utc(2000, 1, 1, 14, 30),
        end_time: Time.utc(2000, 1, 1, 16, 20),
        date: Date.new(2022, 3, 2),
        course_instance: @testCourseInstance
      ),
      CourseEvent.new(
        event_type: @typeLab,
        location: nil,
        day_of_week: DayOfWeekEnum::WEDNESDAY,
        start_time: Time.utc(2000, 1, 1, 14, 30),
        end_time: Time.utc(2000, 1, 1, 16, 20),
        date: Date.new(2022, 3, 2),
        course_instance: @testCourseInstance
      ),
      CourseEvent.new(
        event_type: @typeClass,
        location: nil,
        day_of_week: DayOfWeekEnum::THURSDAY,
        start_time: Time.utc(2000, 1, 1, 9, 30),
        end_time: Time.utc(2000, 1, 1, 11, 20),
        date: nil,
        course_instance: @testCourseInstance
      ),
      CourseEvent.new(
        event_type: @typeTest,
        location: nil,
        day_of_week: DayOfWeekEnum::WEDNESDAY,
        start_time: Time.utc(2000, 1, 1, 10, 30),
        end_time: Time.utc(2000, 1, 1, 11, 20),
        date: Date.new(2022, 5, 29),
        course_instance: @testCourseInstance
      ),
      CourseEvent.new(
        event_type: @typeTest,
        location: nil,
        day_of_week: DayOfWeekEnum::FRIDAY,
        start_time: Time.utc(2000, 1, 1, 10, 30),
        end_time: Time.utc(2000, 1, 1, 11, 20),
        date: Date.new(2022, 7, 1),
        course_instance: @testCourseInstance
      )
    ]
    testScheduleRow = WeekScheduleRow.new()

    testEvents.each do |ev|
      ev.save!()
      testScheduleRow.addEvent(ev)
    end

    assert_equal([], testScheduleRow.monday)
    assert_equal([], testScheduleRow.tuesday)
    assert_equal([testEvents[0], testEvents[1]], testScheduleRow.wednesday)
    assert_equal([testEvents[2]], testScheduleRow.thursday)
    assert_equal([], testScheduleRow.friday)
  end

  test "addEvent success 05" do
    unusedEvent = CourseEvent.new(
      event_type: @typeClass,
      location: nil,
      day_of_week: DayOfWeekEnum::WEDNESDAY,
      start_time: Time.utc(2000, 1, 1, 12, 30),
      end_time: Time.utc(2000, 1, 1, 15, 20),
      date: Date.new(2022, 3, 2),
      course_instance: CourseInstance.new(
        nrc: "13",
        title: "FooCourse",
        teacher: "Mr. Bean",
        credits: 6,
        career: "ING",
        course_number: 2212,
        section: "1",
        curriculum: "PE2016",
        academic_period: @testPeriod
      )
    )
    unusedEvent.save!()

    testEvents = [
      CourseEvent.new(
        event_type: @typeAssist,
        location: nil,
        day_of_week: DayOfWeekEnum::WEDNESDAY,
        start_time: Time.utc(2000, 1, 1, 14, 30),
        end_time: Time.utc(2000, 1, 1, 16, 20),
        date: Date.new(2022, 3, 2),
        course_instance: @testCourseInstance
      ),
      CourseEvent.new(
        event_type: @typeLab,
        location: nil,
        day_of_week: DayOfWeekEnum::WEDNESDAY,
        start_time: Time.utc(2000, 1, 1, 14, 30),
        end_time: Time.utc(2000, 1, 1, 16, 20),
        date: Date.new(2022, 3, 2),
        course_instance: @testCourseInstance
      ),
      CourseEvent.new(
        event_type: @typeClass,
        location: nil,
        day_of_week: DayOfWeekEnum::THURSDAY,
        start_time: Time.utc(2000, 1, 1, 9, 30),
        end_time: Time.utc(2000, 1, 1, 11, 20),
        date: nil,
        course_instance: @testCourseInstance
      ),
      CourseEvent.new(
        event_type: @typeTest,
        location: nil,
        day_of_week: DayOfWeekEnum::WEDNESDAY,
        start_time: Time.utc(2000, 1, 1, 10, 30),
        end_time: Time.utc(2000, 1, 1, 11, 20),
        date: Date.new(2022, 5, 29),
        course_instance: @testCourseInstance
      ),
      CourseEvent.new(
        event_type: @typeTest,
        location: nil,
        day_of_week: DayOfWeekEnum::FRIDAY,
        start_time: Time.utc(2000, 1, 1, 10, 30),
        end_time: Time.utc(2000, 1, 1, 11, 20),
        date: Date.new(2022, 7, 1),
        course_instance: @testCourseInstance
      )
    ]
    testScheduleRow = WeekScheduleRow.new()

    testEvents.each do |ev|
      ev.save!()
      testScheduleRow.addEvent(ev)
    end

    assert_equal([], testScheduleRow.monday)
    assert_equal([], testScheduleRow.tuesday)
    assert_equal([testEvents[0], testEvents[1]], testScheduleRow.wednesday)
    assert_equal([testEvents[2]], testScheduleRow.thursday)
    assert_equal([], testScheduleRow.friday)
  end
end
