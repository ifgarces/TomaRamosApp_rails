require "enums/day_of_week_enum"
require "events_logic/week_schedule_row"

# Deals with mapping respective course events for each block in a week schedule.
module WeekSchedule
  FIRST_BLOCK_HOUR = 8
  LAST_BLOCK_HOUR = 21

  BLOCK_START_MINUTES = 30
  BLOCK_END_MINUTES = 20

  # @param courseInstances [Array<CourseInstance>]
  # @return [Array<WeekScheduleRow>]
  def self.computeWeekScheduleBlocks(courseInstances)
    raise ArgumentError.new(
      "Argument is not an iterable of CourseInstance, or is empty: #{courseInstances}"
    ) unless ((courseInstances.count() > 0) && (courseInstances.first().is_a?(CourseInstance)))

    # Initializing array of fixed size
    result = []
    (LAST_BLOCK_HOUR - FIRST_BLOCK_HOUR).times { result.append(WeekScheduleRow.new()) }

    # Filling array
    courseInstances.each do |course|
      course.getEventsClasses().to_a().concat(
        course.getEventsAssistantshipsAndLabs().to_a()
      ).each do |event|
        # Adding event for each block it occupies
        blockStart, blockEnd = self.timeIntervalToBlockIndexInterval(event.start_time, event.end_time)

        (blockStart..blockEnd).each do |blockIdx|
          result[blockIdx].addEvent(
            dayOfWeek: event.day_of_week, courseEvent: event
          )
        end
      end
    end

    return result
  end

  # @return [Integer]
  def self.timeToBlockIndex(hour, minute)
    supportedHourRange = (FIRST_BLOCK_HOUR..LAST_BLOCK_HOUR)

    blockIndex = supportedHourRange.find_index(hour)

    if (
      (hour < FIRST_BLOCK_HOUR) ||
      ((hour == FIRST_BLOCK_HOUR) && (minute < BLOCK_START_MINUTES))
    )
      return nil
    end

    if (
      (hour > LAST_BLOCK_HOUR) ||
      ((hour == LAST_BLOCK_HOUR) && (minute > BLOCK_END_MINUTES))
    )
      return nil
    end
    return blockIndex
  end

  # @param startTime [Time]
  # @param endTime [Time]
  # @return [Array<Integer, Integer>] Or `nil` in case the provided time interval is not in a
  # supported schedule range.
  def self.timeIntervalToBlockIndexInterval(startTime, endTime)
    startIndex = self.timeToBlockIndex(startTime.hour, startTime.min)
    endIndex = self.timeToBlockIndex(endTime.hour, endTime.min)

    if (startIndex.nil? || endIndex.nil?)
      return nil
    end

    if (startTime.min < 30)
      startIndex -= 1
    end

    if (endTime.min <= 20)
      endIndex -= 1
    end

    return [startIndex, endIndex]
  end
end
