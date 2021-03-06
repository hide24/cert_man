class User < ApplicationRecord
  rolify
  has_many :hosts, through: :user_hosts
  has_many :organizations, through: :user_organizations
  belongs_to :current_organization, class_name: "Organization", optional: true
  has_many :certificate_applications
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :ldap_authenticatable
#  devise :database_authenticatable, :registerable,
#         :rememberable, :validatable
end
