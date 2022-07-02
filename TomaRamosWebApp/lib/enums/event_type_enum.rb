module EventTypeEnum
  CLASS = "CLAS"
  ASSISTANTSHIP = "AYUD"
  LABORATORY = "LABT"
  TEST = "PRBA"
  EXAM = "EXAM"

  # @param eventTypeStr [String]
  # @return [Boolean]
  def self.validate(eventTypeStr)
    return [
      EventTypeEnum::CLASS,
      EventTypeEnum::ASSISTANTSHIP,
      EventTypeEnum::LABORATORY,
      EventTypeEnum::TEST,
      EventTypeEnum::EXAM
    ].include?(eventTypeStr)
  end
end
