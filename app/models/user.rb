class User < ApplicationRecord
    # Include default devise modules. Others available are:
    # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
    devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :trackable, :confirmable
    validates :email, presence: true, uniqueness: true, email: true

    #has_secure_password
    has_one_attached :image, :dependent => :destroy
    has_many :user_ramos_inscriptions, :dependent => :destroy
end
