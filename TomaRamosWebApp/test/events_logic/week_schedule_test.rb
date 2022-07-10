require "test_helper"
require "time"
require "enums/day_of_week_enum"
require "events_logic/week_schedule"
require "events_logic/week_schedule_row"

class WeekScheduleTest < ActiveSupport::TestCase
  setup do
    assert_equal(0, AcademicPeriod.count())
    assert_equal(0, CourseInstance.count())
    assert_equal(0, CourseEvent.count())

    @testPeriod = AcademicPeriod.new(name: "abc3")

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
  end

  test "computeWeekScheduleBlocks 01" do
    testCourses = [
      CourseInstance.new(
        nrc: "4444",
        title: "ALGEBRA E INTR. AL CALCULO",
        teacher: "tata Sánchez la leyenda",
        credits: 10,
        career: "ING",
        course_number: 1100,
        section: "1",
        curriculum: "PE2016",
        academic_period: @testPeriod,
        course_events: [
          CourseEvent.new(
            event_type: @typeClass,
            location: "R-14",
            day_of_week: DayOfWeekEnum::FRIDAY,
            start_time: Time.utc(2000, 1, 1, 8, 30),
            end_time: Time.utc(2000, 1, 1, 10, 20),
            date: Date.new(2022, 3, 2)
          ),
          CourseEvent.new(
            event_type: @typeAssist,
            location: "CEN-101",
            day_of_week: DayOfWeekEnum::MONDAY,
            start_time: Time.utc(2000, 1, 1, 14, 30),
            end_time: Time.utc(2000, 1, 1, 16, 20),
            date: Date.new(2022, 3, 7)
          )
        ]
      )
    ]
    testCourses.each do |course|
      course.save!()
    end

    expectedScheduleRowClass = WeekScheduleRow.new()
    expectedScheduleRowClass.addEvent(
      testCourses.first().course_events.first()
    )

    expectedScheduleRowAssist = WeekScheduleRow.new()
    expectedScheduleRowAssist.addEvent(
      testCourses.first().course_events.second()
    )

    expectedSchedule = [expectedScheduleRowClass, expectedScheduleRowClass]

    gotSchedule = WeekSchedule.computeWeekScheduleBlocks(testCourses)

    assert_equal(expectedSchedule, gotSchedule)
  end

  test "timeIntervalToBlockIndexInterval 01" do
    got = WeekSchedule.timeIntervalToBlockIndexInterval(
      Time.utc(2000, 1, 1, 9, 30), Time.utc(2000, 1, 1, 9, 45)
    )
    assert_equal([1, 1], got)
  end

  test "timeIntervalToBlockIndexInterval 02" do
    got = WeekSchedule.timeIntervalToBlockIndexInterval(
      Time.utc(2000, 1, 1, 7, 30), Time.utc(2000, 1, 1, 9, 45)
    )
    assert_nil(got)
  end

  test "timeIntervalToBlockIndexInterval 03" do
    got = WeekSchedule.timeIntervalToBlockIndexInterval(
      Time.utc(2000, 1, 1, 22, 0), Time.utc(2000, 1, 1, 22, 45)
    )
    assert_nil(got)
  end

  test "timeIntervalToBlockIndexInterval 04" do
    got = WeekSchedule.timeIntervalToBlockIndexInterval(
      Time.utc(2000, 1, 1, 20, 0), Time.utc(2000, 1, 1, 22, 30)
    )
    assert_nil(got)
  end

  test "timeIntervalToBlockIndexInterval 05" do
    got = WeekSchedule.timeIntervalToBlockIndexInterval(
      Time.utc(2000, 1, 1, 13, 30), Time.utc(2000, 1, 1, 16, 20)
    )
    assert_equal([5, 7], got)
  end

  test "timeIntervalToBlockIndexInterval 06" do
    got = WeekSchedule.timeIntervalToBlockIndexInterval(
      Time.utc(2000, 1, 1, 13, 30), Time.utc(2000, 1, 1, 16, 21)
    )
    assert_equal([5, 8], got)
  end

  test "timeIntervalToBlockIndexInterval 07" do
    got = WeekSchedule.timeIntervalToBlockIndexInterval(
      Time.utc(2000, 1, 1, 13, 30), Time.utc(2000, 1, 1, 14, 20)
    )
    assert_equal([5, 5], got)
  end

  test "timeIntervalToBlockIndexInterval 08" do
    got = WeekSchedule.timeIntervalToBlockIndexInterval(
      Time.utc(2000, 1, 1, 13, 30), Time.utc(2000, 1, 1, 14, 25)
    )
    assert_equal([5, 6], got)
  end

  test "timeIntervalToBlockIndexInterval 09" do
    got = WeekSchedule.timeIntervalToBlockIndexInterval(
      Time.utc(2000, 1, 1, 20, 30), Time.utc(2000, 1, 1, 21, 0)
    )
    assert_equal([12, 12], got)
  end

  test "timeIntervalToBlockIndexInterval 10" do
    got = WeekSchedule.timeIntervalToBlockIndexInterval(
      Time.utc(2000, 1, 1, 10, 00), Time.utc(2000, 1, 1, 10, 15)
    )
    assert_equal([1, 1], got)
  end

  test "timeIntervalToBlockIndexInterval 11" do
    got = WeekSchedule.timeIntervalToBlockIndexInterval(
      Time.utc(2000, 1, 1, 8, 30), Time.utc(2000, 1, 1, 10, 20)
    )
    assert_equal([0, 1], got)
  end

  test "timeIntervalToBlockIndexInterval 12" do
    got = WeekSchedule.timeIntervalToBlockIndexInterval(
      Time.utc(2000, 1, 1, 8, 30), Time.utc(2000, 1, 1, 10, 21)
    )
    assert_equal([0, 2], got)
  end

  test "timeIntervalToBlockIndexInterval 13" do
    got = WeekSchedule.timeIntervalToBlockIndexInterval(
      Time.utc(2000, 1, 1, 8, 30), Time.utc(2000, 1, 1, 9, 0)
    )
    assert_equal([0, 0], got)
  end
end
