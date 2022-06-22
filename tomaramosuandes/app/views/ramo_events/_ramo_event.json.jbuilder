json.extract! ramo_event, :id, :location, :day_of_week, :start_time, :end_time, :date, :created_at, :updated_at
json.url ramo_event_url(ramo_event, format: :json)
