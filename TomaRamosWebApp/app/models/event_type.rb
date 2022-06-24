require "utils/event_type_enum"

# Static enum-like db table, for defining the type of each `CourseEvent`.
#
# @!attribute name
#   @return [String] E.g. "clase", "ayudantía".

class EventType < ApplicationRecord
  has_many :course_events

  # Checks whether the event is an evaluation (unique event) or not (weekly recurrent event such as
  # classes).
  # @return [Boolean]
  def isEvaluation()
    return [EventTypeEnum::TEST, EventTypeEnum::EXAM].include?(self.name)
  end
end
