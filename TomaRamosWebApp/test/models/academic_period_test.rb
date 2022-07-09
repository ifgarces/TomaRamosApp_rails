require "test_helper"

class AcademicPeriodTest < ActiveSupport::TestCase
  setup do
    count = AcademicPeriod.count()
    raise RuntimeError.new(
      "AcademicPeriod table is not empty (#{count})"
    ) unless (count == 0)
  end

  test "insert success" do
    testPeriod = getFooAcademicPeriod()
    assert(testPeriod.save())
  end
end
