class Certificate < ApplicationRecord
  belongs_to :host
  before_create :create_csr
  after_create :set_version

  attribute :certificate_key, :pkey
  attribute :certificate_request, :csr
  attribute :certificate, :cer

  def set_version
    Certificate.transaction do
      current_version = Certificate.where(host_id: self.host_id).maximum(:version) || 0
      self.version = current_version.succ
      self.save!
    end
  end

  def create_pkey
    rsa = OpenSSL::PKey::RSA.generate 2048
    self.certificate_key = rsa
  end

  def create_csr
    create_pkey if certificate_key.blank?

    csr = OpenSSL::X509::Request.new
    csr.subject = host.x509_name
    csr.public_key = certificate_key.public_key
    csr.sign(certificate_key, 'sha1')

    self.certificate_request = csr
  end

  def striped_request
    begin_mark = '-----BEGIN CERTIFICATE REQUEST-----'
    end_mark = '-----END CERTIFICATE REQUEST-----'
    certificate_request.to_s.sub(begin_mark, '').sub(end_mark, '').gsub(/\n/, '')
  end

  def validate_certificate
    begin
      cer = OpenSSL::X509::Certificate.new(@new_cert.certificate)
    rescue
      errors.add(:certificate, 'certificate should be X509 certificate.')
    end
  end
end

