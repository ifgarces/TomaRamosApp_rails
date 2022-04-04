require "date"

# Public module that contains references to the current valid academic period and its courses.
module CatalogStatus
public
    # @return [AcademicPeriod] the `AcademicPeriod` the current catalog's `Ramo`s belong to.
    def self.getAcademicPeriod()
        return AcademicPeriod.find_by(name: "2022-10")
    end

    # @return [Date] the date in which the current catalog `Ramo`s was updated for the last time.
    def self.getLastUpdatedDate()
        return Date.strptime("26-03-2022", "%d-%m-%Y")
    end
end
