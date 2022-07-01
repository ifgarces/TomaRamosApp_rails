# Simply maps an user with their collection of `Course`s inscribed for a given `AcademicPeriod`, so
# it makes possible to store historical data for previous periods for that user.

class Inscription < ApplicationRecord
  belongs_to :user
  has_and_belongs_to_many :course_instances

  # @return [Array<RamoEvent>] the events for all inscribed `Ramo`s that are evaluation (tests and exams).
  def get_user_evaluations()
    raise NotImplementedError.new("DEPRECATED METHOD NEEDING UPDATE!") #!

    evals = []
    self.ramos.each do |ramo|
      ramo.ramo_events.each do |ramo_event|
        if (ramo_event.is_evaluation())
          evals.append(ramo_event)
        end
      end
    end
    return evals
  end
end
