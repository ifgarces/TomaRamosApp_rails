class RamoEvent < ApplicationRecord
    belongs_to :ramo
    belongs_to :ramo_event_type
end
