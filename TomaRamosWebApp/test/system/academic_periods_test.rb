require "application_system_test_case"

class AcademicPeriodsTest < ApplicationSystemTestCase
  setup do
    @academic_period = academic_periods(:one)
  end

  test "visiting the index" do
    visit academic_periods_url
    assert_selector "h1", text: "Academic periods"
  end

  test "should create academic period" do
    visit academic_periods_url
    click_on "New academic period"

    fill_in "Name", with: @academic_period.name
    click_on "Create Academic period"

    assert_text "Academic period was successfully created"
    click_on "Back"
  end

  test "should update Academic period" do
    visit academic_period_url(@academic_period)
    click_on "Edit this academic period", match: :first

    fill_in "Name", with: @academic_period.name
    click_on "Update Academic period"

    assert_text "Academic period was successfully updated"
    click_on "Back"
  end

  test "should destroy Academic period" do
    visit academic_period_url(@academic_period)
    click_on "Destroy this academic period", match: :first

    assert_text "Academic period was successfully destroyed"
  end
end
