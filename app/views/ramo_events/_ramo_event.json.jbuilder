json.extract! ramo_event, :id, :type, :day_of_week, :start_timestamp, :end_timestamp, :date, :created_at, :updated_at
json.url ramo_event_url(ramo_event, format: :json)
