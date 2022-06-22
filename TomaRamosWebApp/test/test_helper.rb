ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # @param expectedError [Exception]
  # @param gotError [Exception]
  def assertExceptionsEqual(expectedError:, gotError:)
    assert_equal(expectedError.class, gotError.class)
    assert_equal(expectedError.message, gotError.message)
  end
end
