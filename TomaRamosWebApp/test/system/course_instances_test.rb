require "application_system_test_case"

class CourseInstancesTest < ApplicationSystemTestCase
  setup do
    @course_instance = course_instances(:one)
  end

  test "visiting the index" do
    visit course_instances_url
    assert_selector "h1", text: "Course instances"
  end

  test "should create course instance" do
    visit course_instances_url
    click_on "New course instance"

    fill_in "Career", with: @course_instance.career
    fill_in "Course number", with: @course_instance.course_number
    fill_in "Credits", with: @course_instance.credits
    fill_in "Curriculum", with: @course_instance.curriculum
    fill_in "Lcruz", with: @course_instance.lcruz
    fill_in "Liga", with: @course_instance.liga
    fill_in "Nrc", with: @course_instance.nrc
    fill_in "Section", with: @course_instance.section
    fill_in "Teacher", with: @course_instance.teacher
    fill_in "Title", with: @course_instance.title
    click_on "Create Course instance"

    assert_text "Course instance was successfully created"
    click_on "Back"
  end

  test "should update Course instance" do
    visit course_instance_url(@course_instance)
    click_on "Edit this course instance", match: :first

    fill_in "Career", with: @course_instance.career
    fill_in "Course number", with: @course_instance.course_number
    fill_in "Credits", with: @course_instance.credits
    fill_in "Curriculum", with: @course_instance.curriculum
    fill_in "Lcruz", with: @course_instance.lcruz
    fill_in "Liga", with: @course_instance.liga
    fill_in "Nrc", with: @course_instance.nrc
    fill_in "Section", with: @course_instance.section
    fill_in "Teacher", with: @course_instance.teacher
    fill_in "Title", with: @course_instance.title
    click_on "Update Course instance"

    assert_text "Course instance was successfully updated"
    click_on "Back"
  end

  test "should destroy Course instance" do
    visit course_instance_url(@course_instance)
    click_on "Destroy this course instance", match: :first

    assert_text "Course instance was successfully destroyed"
  end
end
