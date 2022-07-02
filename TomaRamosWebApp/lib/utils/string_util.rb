require "time"

module StringUtil
  # @param startTime [Time]
  # @param endTime [Time]
  # @return [String]
  def self.getReadableTimeInterval(startTime, endTime)
    return "%s:%s – %s:%s" % [startTime.hour, startTime.min, endTime.hour, endTime.min]
  end
end
