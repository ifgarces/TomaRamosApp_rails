class Ramo < ApplicationRecord
    has_many :ramo_event, :dependent => :destroy
end
