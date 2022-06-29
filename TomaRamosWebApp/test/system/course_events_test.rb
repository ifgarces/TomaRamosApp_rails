require "application_system_test_case"

class CourseEventsTest < ApplicationSystemTestCase
  setup do
    @course_event = course_events(:one)
  end

  test "visiting the index" do
    visit course_events_url
    assert_selector "h1", text: "Course events"
  end

  test "should create course event" do
    visit course_events_url
    click_on "New course event"

    fill_in "Date", with: @course_event.date
    fill_in "Day of week", with: @course_event.day_of_week
    fill_in "End time", with: @course_event.end_time
    fill_in "Location", with: @course_event.location
    fill_in "Start time", with: @course_event.start_time
    click_on "Create Course event"

    assert_text "Course event was successfully created"
    click_on "Back"
  end

  test "should update Course event" do
    visit course_event_url(@course_event)
    click_on "Edit this course event", match: :first

    fill_in "Date", with: @course_event.date
    fill_in "Day of week", with: @course_event.day_of_week
    fill_in "End time", with: @course_event.end_time
    fill_in "Location", with: @course_event.location
    fill_in "Start time", with: @course_event.start_time
    click_on "Update Course event"

    assert_text "Course event was successfully updated"
    click_on "Back"
  end

  test "should destroy Course event" do
    visit course_event_url(@course_event)
    click_on "Destroy this course event", match: :first

    assert_text "Course event was successfully destroyed"
  end
end
