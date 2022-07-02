module CareerEnum
  ING = "PLAN COMÚN"
  ICC = "COMPUTACIÓN"
  ICI = "INDUSTRIAL"
  ICE = "ELÉCTRICA"
  ICA = "AMBIENTAL"

  # @param career [String]
  # @return [CareerEnum] Or `nil` in case the value is invalid or not recognized.
  def self.parseStringCareer(career)
    validValues = [
      CareerEnum::ING,
      CareerEnum::ICC,
      CareerEnum::ICI,
      CareerEnum::ICE,
      CareerEnum::ICA
    ]

    return validValues.include?(career) ? career : nil

    # raise ArgumentError.new(
    #   "Provided value '%s' is not a valid CareerEnum, must be one of %s" % [career, validValues]
    # ) unless validValues.include?(career)
    # return career
  end
end
