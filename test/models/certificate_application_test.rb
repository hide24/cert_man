require 'test_helper'

class CertificateApplicationTest < ActiveSupport::TestCase
  def setup
    @certificate_application = certificate_applications(:one)
    @organization = organizations(:one)
    @host = hosts(:one)
    @host.organization = @organization
    @host.save
    @host2 = hosts(:two)
    @host2.organization = @organization
    @host2.save
    @certificate = certificates(:one)
    @certificate.host = @host
    @certificate.save
    @certificate_application.certificates << @certificate
    @certificate_application.save
  end

  test "should create certifications" do
    assert_difference('@certificate_application.certificates.count') do
      @certificate_application.register(@host.id)
      @certificate_application.save
    end
    assert_equal @host.id, @certificate_application.certificates.first.host_id
  end

  test "should create certifications(array)" do
    assert_difference('@certificate_application.certificates.count', 2) do
      @certificate_application.register([@host.id, @host2.id])
      @certificate_application.save
    end
    assert_equal @host.id, @certificate_application.certificates.first.host_id
    assert_equal @host2.id, @certificate_application.certificates.last.host_id
  end

  test "should create certifications(multi value)" do
    assert_difference('@certificate_application.certificates.count', 2) do
      @certificate_application.register(@host.id, @host2.id)
      @certificate_application.save
    end
  end

  test "should create certifications(object)" do
    assert_difference('@certificate_application.certificates.count') do
      @certificate_application.register(@host)
      @certificate_application.save
    end
  end

  test "should create certifications(add)" do
    @certificate_application.register(@host2)
    @certificate_application.save
    assert_difference('@certificate_application.certificates.count') do
      @certificate_application.register(@host)
      @certificate_application.save
    end
  end

  test "should ignore host_id attribute when create" do
    assert_kind_of(CertificateApplication, CertificateApplication.new(host_id: @host.id))
  end

  test "shoud check uploaded file(success)" do
    result = @certificate_application.check_uploaded_file(file_fixture('one.cer').read)
    assert_equal @certificate.id, result[:certificate].id
    assert_equal [], result[:errors]
    assert_equal 'success', result[:status]
  end

  test "shoud check uploaded file(failer)" do
    result = @certificate_application.check_uploaded_file(file_fixture('invalid.cer').read)
    assert_nil result[:certificate]
    assert_equal ['There is no applicatable CSR.'], result[:errors]
    assert_equal 'error', result[:status]
  end
end
