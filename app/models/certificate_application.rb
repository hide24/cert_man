class CertificateApplication < ApplicationRecord
  belongs_to :user
  has_many :certificates
  has_many :hosts, through: :certificates
end
