require "test_helper"

class AppMetadataControllerTest < ActionDispatch::IntegrationTest
  setup do
    @app_metadatum = app_metadata(:one)
  end

  test "should get index" do
    get app_metadata_url
    assert_response :success
  end

  test "should get new" do
    get new_app_metadatum_url
    assert_response :success
  end

  test "should create app_metadatum" do
    assert_difference("AppMetadatum.count") do
      post app_metadata_url, params: { app_metadatum: { catalog_current_period: @app_metadatum.catalog_current_period, catalog_last_updated: @app_metadatum.catalog_last_updated, latest_version_name: @app_metadatum.latest_version_name } }
    end

    assert_redirected_to app_metadatum_url(AppMetadatum.last)
  end

  test "should show app_metadatum" do
    get app_metadatum_url(@app_metadatum)
    assert_response :success
  end

  test "should get edit" do
    get edit_app_metadatum_url(@app_metadatum)
    assert_response :success
  end

  test "should update app_metadatum" do
    patch app_metadatum_url(@app_metadatum), params: { app_metadatum: { catalog_current_period: @app_metadatum.catalog_current_period, catalog_last_updated: @app_metadatum.catalog_last_updated, latest_version_name: @app_metadatum.latest_version_name } }
    assert_redirected_to app_metadatum_url(@app_metadatum)
  end

  test "should destroy app_metadatum" do
    assert_difference("AppMetadatum.count", -1) do
      delete app_metadatum_url(@app_metadatum)
    end

    assert_redirected_to app_metadata_url
  end
end
