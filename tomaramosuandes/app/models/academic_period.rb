class AcademicPeriod < ApplicationRecord
    has_many :ramos

public
    # @return [Array<Ramo>] the collection of `Ramo`s belonging to the academic period.
    def get_ramos()
        return Ramo.where(academic_period: self.id)
    end
end
