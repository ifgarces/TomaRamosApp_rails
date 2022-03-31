class RamoEvent < ApplicationRecord
    belongs_to :ramo
    belongs_to :ramo_event_type

public
    # @return [String]
    def getDescriptionLong()
        return %{
Tipo: #{self.ramo_event_type.toStringLarge()}
Ramo: #{""}
}.strip()
    end

    # @return [String]
    def getDescriptionShort()
        raise NotImplementedError
    end
end
