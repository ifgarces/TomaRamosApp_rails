require "application_system_test_case"

class AppMetadataTest < ApplicationSystemTestCase
  setup do
    @app_metadatum = app_metadata(:one)
  end

  test "visiting the index" do
    visit app_metadata_url
    assert_selector "h1", text: "App metadata"
  end

  test "should create app metadatum" do
    visit app_metadata_url
    click_on "New app metadatum"

    fill_in "Catalog current period", with: @app_metadatum.catalog_current_period
    fill_in "Catalog last updated", with: @app_metadatum.catalog_last_updated
    fill_in "Latest version name", with: @app_metadatum.latest_version_name
    click_on "Create App metadatum"

    assert_text "App metadatum was successfully created"
    click_on "Back"
  end

  test "should update App metadatum" do
    visit app_metadatum_url(@app_metadatum)
    click_on "Edit this app metadatum", match: :first

    fill_in "Catalog current period", with: @app_metadatum.catalog_current_period
    fill_in "Catalog last updated", with: @app_metadatum.catalog_last_updated
    fill_in "Latest version name", with: @app_metadatum.latest_version_name
    click_on "Update App metadatum"

    assert_text "App metadatum was successfully updated"
    click_on "Back"
  end

  test "should destroy App metadatum" do
    visit app_metadatum_url(@app_metadatum)
    click_on "Destroy this app metadatum", match: :first

    assert_text "App metadatum was successfully destroyed"
  end
end
