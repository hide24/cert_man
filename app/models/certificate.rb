class Certificate < ApplicationRecord
  belongs_to :host
  belongs_to :certificate_application, optional: true
  before_create :create_csr
  after_create :set_version

  attribute :certificate_key, :pkey
  attribute :certificate_request, :csr
  attribute :certificate, :cer

  validate :validate_certificate

  def set_version
    Certificate.transaction do
      current_version = Certificate.where(host_id: self.host_id).maximum(:version) || 0
      self.version = current_version.succ
      self.save!
    end
  end

  def create_pkey
    OpenSSL::Random.seed(File.read("/dev/random", 16))
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
    bigin_mark = "-----BEGIN CERTIFICATE-----\n"
    end_mark = "\n-----END CERTIFICATE-----"

    return if certificate.blank?

    unless certificate.kind_of?(OpenSSL::X509::Certificate)
      cert_text = bigin_mark + certificate + end_mark
      self.certificate = cert_text
    end

    unless certificate.kind_of?(OpenSSL::X509::Certificate)
      errors.add(:certificate, 'certificate should be X509 certificate.')
      return
    end

    unless certificate.subject == certificate_request.subject
      errors.add(:certificate, 'subject does not match.')
    end

    unless certificate.public_key.to_s == certificate_key.public_key.to_s
      errors.add(:certificate, 'RSA public key does not match.')
    end
  end

  def to_tsv
    [
      host.tsv_discription,
      3, nil,
      certificate.try(:serial).to_s,
      nil, nil,
      striped_request,
      host.owner_name,
      host.organization.name,
      host.mail,
      host.hostname,
      'apache2.4', nil
    ].join("\t")
  end

  def not_after
    certificate.not_after
  rescue
    false
  end

  def not_before
    certificate.not_before
  rescue
    false
  end

  def expired?
    !(not_before .. not_after).cover?(Time.now)
  rescue
    false
  end

  def near_expire?
    not_after - Time.now < 2.month
  rescue
    false
  end

  def expiration_date
    [not_before.localtime.strftime('%Y/%m/%d'),
      not_after.localtime.strftime('%Y/%m/%d')].join(' - ')
  rescue
    'in progress'
  end

  def expiration_date_class
    if certificate.blank?
      'warning'
    elsif expired?
      'danger'
    elsif near_expire?
      'warning'
    else
      'success'
    end
  end

  def hostname
    host.hostname
  end
end

