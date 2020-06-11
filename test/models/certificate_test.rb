require 'test_helper'

class CertificateTest < ActiveSupport::TestCase
  def setup
    @certificate = certificates(:one)
    @host = hosts(:one)
    @organization = organizations(:one)
    @host.organization = @organization
    @host.save
    @certificate.host = @host
    @new_cert = Certificate.create(host_id: @host.id)
  end

  test "should set version(first commit)" do
    assert_equal 1, @new_cert.version
  end

  test "should set version(later)" do
    version = rand(10)
    version.times do
      @new_cert = Certificate.create(host_id: @host.id)
    end
    assert_equal version.succ, @new_cert.version
  end

  test "should have pkey" do
    @new_cert.version += 1
    @new_cert.save
    assert_kind_of OpenSSL::PKey::RSA, @new_cert.certificate_key
  end

  test "should have csr with valid subject" do
    assert_includes '/C=JP/ST=Tokyo/L=Chiyoda-Ku/O=FirstOrg/CN=example1.com', @new_cert.certificate_request.subject.to_s
  end

  test "striped_request does not contain header/footer and newlines" do
    assert_not /-----BEGIN CERTIFICATE REQUEST-----/ =~ @new_cert.striped_request
    assert_not /-----END CERTIFICATE REQUEST-----/ =~ @new_cert.striped_request
    assert_not /\n/ =~ @new_cert.striped_request
  end
end
