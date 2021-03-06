class Host < ApplicationRecord
  has_many :users, through: :user_hosts
  has_many :certificates
  belongs_to :organization
  has_one :renewal

  validates :hostname, uniqueness: true

  def x509_name
    name = OpenSSL::X509::Name.new
    organization.entries.each do |k, v|
      name.add_entry(k, v)
    end
    name.add_entry('CN', hostname)
    name
  end

  def tsv_discription
    "CN=#{hostname}," + organization.dn(reverse: true)
  end

  def certificate
    certificates.order('version DESC').first
  end
end
