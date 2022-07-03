require "test_helper"
require "time"
require "events_logic/week_schedule"

class WeekScheduleTest < ActiveSupport::TestCase
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
