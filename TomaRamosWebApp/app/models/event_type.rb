require "enums/event_type_enum"

# Static enum-like db table, for defining the type of each `CourseEvent`.
#
# @!attribute name
#   @return [String] E.g. "clase", "ayudantía".

class EventType < ApplicationRecord
  has_many :course_events

  # @return [Boolean] Whether the event is an evaluation (unique event) or not (weekly recurrent
  # event such as classes)
  def isEvaluation()
    return [EventTypeEnum::TEST, EventTypeEnum::EXAM].include?(self.name)
  end

  # @return [String]
  def toReadableString()
    #TODO
    raise NotImplementedError.new()
  end
end
