class CourseInstance < ApplicationRecord
    has_many :course_events, :dependent => :destroy
    belongs_to :academic_period
    has_and_belongs_to_many :user_course_inscriptions

    validates :nrc, numericality: true
end
