class Ramo < ApplicationRecord
    has_many :ramo_events, :dependent => :destroy
end
