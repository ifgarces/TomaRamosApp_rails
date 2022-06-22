# Static enum-like db table, for defining the type of each `CourseEvent`.
# 
# @!attribute name
#   @return [String] E.g. "clase", "ayudantía".

class EventType < ApplicationRecord
  has_many :course_events

  public

  # Returns the larger description of the event (by its `name`).
  # @return [String]
  def to_string_large()
    return case (self.name)
      when "CLAS"
        "Clase"
      when "AYUD"
        "Ayudantía"
      when "LABT"
        "Laboratorio"
      when "PRBA"
        "Prueba"
      when "EXAM"
        "Examen"
      else
        raise "Unknown EventType name '%s', can't convert to large string" % [self.name]
      end
  end
end
