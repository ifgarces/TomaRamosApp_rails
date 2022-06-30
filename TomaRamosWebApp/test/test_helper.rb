ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

require "date"

# Note: some stuff such as person names are autogenerated, but left hardcoded for better debugging
# (should try to avoid use of `Faker` here)

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order
  fixtures :all

  # Ensuring two errors are equal by type and message.
  # References (thanks): https://stackoverflow.com/a/3454953/12684271
  # @param expectedError [Exception]
  # @param gotError [Exception]
  def assertExceptionsEqual(expectedError:, gotError:)
    assert_equal(expectedError.class, gotError.class)
    assert_equal(expectedError.message, gotError.message)
  end

  # @return [AcademicPeriod]
  def getFooAcademicPeriod()
    return AcademicPeriod.new(name: "2040-10")
  end

  # @param title [String]
  # @return [CourseInstance]
  def getFooCourseInstance(title:)
    return CourseInstance.new(
             nrc: "1234",
             title: title,
             teacher: "Lerma/González Ariadna",
             credits: 6,
             career: "ICC",
             course_number: 666,
             section: 1,
             curriculum: "PE2033",
             academic_period: self.getFooAcademicPeriod()
           )
  end

  # @return [User]
  def getFooUser()
    return User.new(
             email: "deshka@foo.com",
             username: "deshka347",
             password: "qwerty"
           )
  end
end
