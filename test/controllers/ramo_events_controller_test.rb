require "test_helper"

class RamoEventsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @ramo_event = ramo_events(:one)
  end

  test "should get index" do
    get ramo_events_url
    assert_response :success
  end

  test "should get new" do
    get new_ramo_event_url
    assert_response :success
  end

  test "should create ramo_event" do
    assert_difference('RamoEvent.count') do
      post ramo_events_url, params: { ramo_event: { date: @ramo_event.date, day_of_week: @ramo_event.day_of_week, end_timestamp: @ramo_event.end_timestamp, start_timestamp: @ramo_event.start_timestamp, type: @ramo_event.type } }
    end

    assert_redirected_to ramo_event_url(RamoEvent.last)
  end

  test "should show ramo_event" do
    get ramo_event_url(@ramo_event)
    assert_response :success
  end

  test "should get edit" do
    get edit_ramo_event_url(@ramo_event)
    assert_response :success
  end

  test "should update ramo_event" do
    patch ramo_event_url(@ramo_event), params: { ramo_event: { date: @ramo_event.date, day_of_week: @ramo_event.day_of_week, end_timestamp: @ramo_event.end_timestamp, start_timestamp: @ramo_event.start_timestamp, type: @ramo_event.type } }
    assert_redirected_to ramo_event_url(@ramo_event)
  end

  test "should destroy ramo_event" do
    assert_difference('RamoEvent.count', -1) do
      delete ramo_event_url(@ramo_event)
    end

    assert_redirected_to ramo_events_url
  end
end
