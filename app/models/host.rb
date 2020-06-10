class Host < ApplicationRecord
  has_many :users, through: :user_hosts
  has_many :certificates
end
