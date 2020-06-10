require 'test_helper'

class CertificateTest < ActiveSupport::TestCase
  def setup
    @certificate = certificates(:one)
    @host = hosts(:one)
  end

  test "should set version(first commit)" do
    @new_cert = Certificate.create(host_id: @host.id)
    assert_equal 1, @new_cert.version
  end

  test "should set version(later)" do
    version = rand(10) + 1
    version.times do
      @new_cert = Certificate.create(host_id: @host.id)
    end
    assert_equal version, @new_cert.version
  end
end
