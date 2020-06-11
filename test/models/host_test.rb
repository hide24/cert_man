require 'test_helper'

class HostTest < ActiveSupport::TestCase
  def setup
    @host = hosts(:one)
    @organization = organizations(:one)
    @host.organization = @organization
  end

  test "create X509 Name object" do
    assert_kind_of OpenSSL::X509::Name, @host.x509_name
  end

  test "X509 Name object should have discription" do
    assert_includes '/C=JP/ST=Tokyo/L=Chiyoda-Ku/O=FirstOrg/CN=example1.com', @host.x509_name.to_s
  end

  test "create discription string for TSV" do
    assert_equal 'CN=example1.com,O=FirstOrg,L=Chiyoda-Ku,ST=Tokyo,C=JP', @host.tsv_discription
  end
end
