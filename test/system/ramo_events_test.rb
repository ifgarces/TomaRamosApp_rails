require "application_system_test_case"

class RamoEventsTest < ApplicationSystemTestCase
  setup do
    @ramo_event = ramo_events(:one)
  end

  test "visiting the index" do
    visit ramo_events_url
    assert_selector "h1", text: "Ramo events"
  end

  test "should create ramo event" do
    visit ramo_events_url
    click_on "New ramo event"

    fill_in "Date", with: @ramo_event.date
    fill_in "Day of week", with: @ramo_event.day_of_week
    fill_in "End time", with: @ramo_event.end_time
    fill_in "Location", with: @ramo_event.location
    fill_in "Start time", with: @ramo_event.start_time
    click_on "Create Ramo event"

    assert_text "Ramo event was successfully created"
    click_on "Back"
  end

  test "should update Ramo event" do
    visit ramo_event_url(@ramo_event)
    click_on "Edit this ramo event", match: :first

    fill_in "Date", with: @ramo_event.date
    fill_in "Day of week", with: @ramo_event.day_of_week
    fill_in "End time", with: @ramo_event.end_time
    fill_in "Location", with: @ramo_event.location
    fill_in "Start time", with: @ramo_event.start_time
    click_on "Update Ramo event"

    assert_text "Ramo event was successfully updated"
    click_on "Back"
  end

  test "should destroy Ramo event" do
    visit ramo_event_url(@ramo_event)
    click_on "Destroy this ramo event", match: :first

    assert_text "Ramo event was successfully destroyed"
  end
end
