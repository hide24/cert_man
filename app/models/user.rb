class User < ApplicationRecord
  rolify
  has_many :hosts, through: :user_hosts
  has_many :organizations, through: :user_organizations
  belongs_to :current_organization, class_name: "Organization", optional: true
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :rememberable, :validatable
end
