ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

require "date"

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order
  #// fixtures :all

  # @return [AcademicPeriod]
  def getFooAcademicPeriod()
    return AcademicPeriod.new(name: "2040-10")
  end

  # @return [User]
  def getFooUser()
    return User.new(
      email: "deshka@foo.com",
      username: "deshka347",
      password: "qwerty"
    )
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

  # Used to explicitly compare two objects that both could be `nil`. Suppresses the annoying
  # depreciation warning explained here (could not figure out how to force suppress it):
  # https://stackoverflow.com/questions/64551495/ruby-deprecated-use-assert-nil-if-expecting-nil-this-will-fail-in-minitest-6
  #
  # @param left [Object | nil]
  # @param right [Object | nil]
  # @return [nil]
  def assertEqualOrNil(left, right)
    if (left.nil?)
      assert_nil(right)
    elsif (right.nil?)
      assert_nil(left)
    else
      assert_equal(left, right)
    end
  end

  # Ensuring two errors are equal by type and message.
  #* Note: if the `message` contains an `inspect` string, this method will fail with an error
  #* somehow, arguing that there's "No visible difference"
  # References (thanks): https://stackoverflow.com/a/3454953/12684271
  #
  # @param expectedError [Exception]
  # @param gotError [Exception]
  # @return [nil]
  def assertEqualExceptions(expectedError:, gotError:)
    assert(expectedError.is_a?(Exception))
    assert(gotError.is_a?(Exception))
    assert_equal(expectedError.class, gotError.class)
    assert_equal(expectedError.message, gotError.message)
  end

  # @param leftTime [Array<Time> | nil]
  # @param rightTime [Array<Time> | nil]
  # @return [nil]
  def assertEqualTimeInterval(leftInterval, rightInterval)
    if (leftInterval.nil?)
      assert_nil(rightInterval)
      return
    end
    assert_equal(2, leftInterval.count())
    assert_equal(2, rightInterval.count())
    self.assertEqualTimes(leftInterval.first(), rightInterval.first())
    self.assertEqualTimes(leftInterval.last(), rightInterval.last())
  end

  # @param leftTime [Time]
  # @param rightTime [Time]
  # @return [nil]
  def assertEqualTimes(leftTime, rightTime)
    assert(leftTime.is_a?(Time))
    assert(rightTime.is_a?(Time))
    assert_equal(leftTime.hour, rightTime.hour)
    assert_equal(leftTime.min, rightTime.min)
  end

  # @param leftDate [Date]
  # @param rightDate [Date]
  # @return [nil]
  def assertEqualDates(leftDate, rightDate)
    assert(leftDate.is_a?(Date))
    assert(rightDate.is_a?(Date))
    assert_equal(leftDate.year, rightDate.year)
    assert_equal(leftDate.mon, rightDate.mon)
    assert_equal(leftDate.day, rightDate.day)
  end

  # @param leftArr [Array<CourseInstance>]
  # @param rightArr [Array<CourseInstance>]
  # @return [nil]
  def assertEqualCourseInstancesArray(leftArr, rightArr)
    leftArr.each_index do |k|
      self.assertEqualCourseInstances(leftArr[k], rightArr[k])
    end
  end

  # @param leftArr [Array<CourseEvent>]
  # @param rightArr [Array<CourseEvent>]
  # @return [nil]
  def assertEqualCourseEventsArray(leftArr, rightArr)
    assert_equal(leftArr.count(), rightArr.count())
    leftArr.each_index do |k|
      self.assertEqualCourseEvents(leftArr[k], rightArr[k])
    end
  end

  private

  # Compares two `CourseInstance`s without minding IDs nor db timestamps.
  # @param leftCourse [CourseInstance]
  # @param rightCourse [CourseInstance]
  # @return [nil]
  def assertEqualCourseInstances(leftCourse, rightCourse)
    assert_equal(leftCourse.nrc, rightCourse.nrc)
    assert_equal(leftCourse.title, rightCourse.title)
    assert_equal(leftCourse.teacher, rightCourse.teacher)
    assert_equal(leftCourse.credits, rightCourse.credits)
    assert_equal(leftCourse.career, rightCourse.career)
    assert_equal(leftCourse.course_number, rightCourse.course_number)
    assert_equal(leftCourse.section, rightCourse.section)
    assert_equal(leftCourse.curriculum, rightCourse.curriculum)
    assertEqualOrNil(leftCourse.liga, rightCourse.liga)
    assertEqualOrNil(leftCourse.lcruz, rightCourse.lcruz)
    assert_equal(leftCourse.academic_period, rightCourse.academic_period)
  end

  # Compares two `CourseEvent`s without minding IDs nor db timestamps.
  # @param leftEvent [CourseEvent]
  # @param rightEvent [CourseEvent]
  # @return [nil]
  def assertEqualCourseEvents(leftEvent, rightEvent)
    assertEqualOrNil(leftEvent.location, rightEvent.location)
    assert_equal(leftEvent.day_of_week, rightEvent.day_of_week)
    assertEqualTimes(leftEvent.start_time, rightEvent.start_time)
    assertEqualTimes(leftEvent.end_time, rightEvent.end_time)
    assertEqualOrNil(leftEvent.date, rightEvent.date)
    assert_equal(leftEvent.event_type, rightEvent.event_type)
  end
end
