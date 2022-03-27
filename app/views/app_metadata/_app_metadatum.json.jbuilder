json.extract! app_metadatum, :id, :latest_version_name, :catalog_current_period, :catalog_last_updated, :created_at, :updated_at
json.url app_metadatum_url(app_metadatum, format: :json)
