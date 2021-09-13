require "application_system_test_case"

class RamoEventsTest < ApplicationSystemTestCase
  setup do
    @ramo_event = ramo_events(:one)
  end

  test "visiting the index" do
    visit ramo_events_url
    assert_selector "h1", text: "Ramo Events"
  end

  test "creating a Ramo event" do
    visit ramo_events_url
    click_on "New Ramo Event"

    fill_in "Date", with: @ramo_event.date
    fill_in "Day of week", with: @ramo_event.day_of_week
    fill_in "End timestamp", with: @ramo_event.end_timestamp
    fill_in "Start timestamp", with: @ramo_event.start_timestamp
    fill_in "Type", with: @ramo_event.type
    click_on "Create Ramo event"

    assert_text "Ramo event was successfully created"
    click_on "Back"
  end

  test "updating a Ramo event" do
    visit ramo_events_url
    click_on "Edit", match: :first

    fill_in "Date", with: @ramo_event.date
    fill_in "Day of week", with: @ramo_event.day_of_week
    fill_in "End timestamp", with: @ramo_event.end_timestamp
    fill_in "Start timestamp", with: @ramo_event.start_timestamp
    fill_in "Type", with: @ramo_event.type
    click_on "Update Ramo event"

    assert_text "Ramo event was successfully updated"
    click_on "Back"
  end

  test "destroying a Ramo event" do
    visit ramo_events_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Ramo event was successfully destroyed"
  end
end
