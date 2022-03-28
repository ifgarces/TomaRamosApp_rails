class User < ApplicationRecord
    has_one_attached :image, :dependent => :destroy
    has_secure_password

    has_many :ramo, :dependent => :destroy
end
