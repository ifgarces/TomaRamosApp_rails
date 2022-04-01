class User < ApplicationRecord
    has_one_attached :image, :dependent => :destroy
    has_secure_password

    has_many :user_ramos_inscriptions, :dependent => :destroy
end
