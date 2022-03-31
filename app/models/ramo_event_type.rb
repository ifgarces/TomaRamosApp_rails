class RamoEventType < ApplicationRecord
    has_many :ramo_events

public
    # Returns the larger description of the event (by its `name`).
    # @return [String]
    def toStringLarge()
        return
            case self.name
            when "CLAS"
                "Clase"
            when "AYUD"
                "Ayudantía"
            when "LABT"
                "Laboratorio"
            when "PRBA"
                "Prueba"
            when "EXAM"
                "Examen"
            else
                raise "Unexpected RamoEventType name '%s', can't convert to large string" % [self.name]
            end
    end
end
