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
end
