class AcademicPeriod < ApplicationRecord
    has_many :ramos

    public

    # @return [Array<CourseInstance>] the collection of `CourseInstance`s belonging to the academic
    # period.
    def get_ramos()
        return CourseInstance.where(academic_period: self.id)
    end
end
