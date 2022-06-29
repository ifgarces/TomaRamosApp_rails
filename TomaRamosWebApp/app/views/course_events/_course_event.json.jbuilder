json.extract! course_event, :id, :location, :day_of_week, :start_time, :end_time, :date, :created_at, :updated_at
json.url course_event_url(course_event, format: :json)
