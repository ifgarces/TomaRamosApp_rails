#! ---
#! DEPRECATED
#! ---

require "date"

# Public module that contains references to the current valid academic period and its courses.
module CatalogStatus
public
    PERIOD_NAME = "2022-10"

    # @return [AcademicPeriod] the `AcademicPeriod` the current catalog's `Ramo`s belong to.
    def self.get_academic_period()
        return AcademicPeriod.find_by(name: CatalogStatus::PERIOD_NAME)
    end

    # @return [Date] the date in which the current catalog `Ramo`s was updated for the last time.
    def self.get_last_updated_date()
        return Date.strptime("26-03-2022", "%d-%m-%Y")
    end
end
