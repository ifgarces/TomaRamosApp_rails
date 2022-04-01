class Ramo < ApplicationRecord
    has_many :ramo_events, :dependent => :destroy
    belongs_to :academic_period
    has_and_belongs_to_many :user_ramos_inscriptions
end
