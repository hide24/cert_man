class CertificateApplication < ApplicationRecord
#  belongs_to :user
  has_many :certificates
  has_many :hosts, through: :certificates

  def initialize(params)
    if params && params.key?(:host_id)
      params.delete(:host_id)
    end
    super
  end

  def register(*hosts)
    logger.info("---foo:%s-----" % hosts.inspect)
    [hosts].flatten.each do |host|
    logger.info("---bar:%s-----" % host.inspect)
      host_id = (host.kind_of?(Host)? host.id: host)
      self.certificates.build(host_id: host_id)
    end
  end
end
