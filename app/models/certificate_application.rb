class CertificateApplication < ApplicationRecord
  belongs_to :user, optional: true
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

  def check_uploaded_file(file)
    errors = []
    upload_certificate = nil
    begin
      upload_certificate = OpenSSL::X509::Certificate.new(file)
    rescue
      errors << 'this is not X509 Certification.'
      return {certificate: nil, errors: errors, status: 'error'}
    end

    csr = certificates.select{|c| c.certificate_request.subject == upload_certificate.subject}.first

    unless csr
      errors << 'There is no applicatable CSR.'
      return {certificate: nil, errors: errors, status: 'error'}
    end

    unless csr.certificate_key.public_key.to_s == upload_certificate.public_key.to_s
      errors << 'RSA public key does not match.'
      return {certificate: csr, errors: errors, status: 'error'}
    end

    {certificate: csr, errors: errors, status: 'success'}
  end

  def to_tsv
    certificates.map(&:to_tsv).join("\n")
  end

  def basename
    created_at.localtime.strftime('%Y%m%d-%H%M%S')
  end

  def to_zip
    buffer = Zip::OutputStream.write_buffer do |zos|
      certificates.each do |certificate|
        zos.put_next_entry(certificate.hostname + '.key')
        zos.write(certificate.certificate_key.to_s)
        if certificate.certificate.present?
          zos.put_next_entry(certificate.hostname + '.cer')
          zos.write(certificate.certificate.to_s)
        end
      end
    end
    buffer.string
  end
end
