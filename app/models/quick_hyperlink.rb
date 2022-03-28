class QuickHyperlink < ApplicationRecord
    has_one_attached :image, :dependant => :destroy
end
