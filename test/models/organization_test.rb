require 'test_helper'

class OrganizationTest < ActiveSupport::TestCase
  def setup
    @org_one = organizations(:one)
    @org_two = organizations(:two)
  end

  test "generate dn string" do
    assert_equal 'C=JP,ST=Tokyo,L=Chiyoda-Ku,O=FirstOrg', @org_one.dn
    assert_equal 'C=UK,ST=London,O=SecondOrg,OU=UnitName', @org_two.dn
  end

  test "generate dn string reverse order" do
    assert_equal 'O=FirstOrg,L=Chiyoda-Ku,ST=Tokyo,C=JP', @org_one.dn(reverse: true)
    assert_equal 'OU=UnitName,O=SecondOrg,ST=London,C=UK', @org_two.dn(reverse: true)
  end

  test "generate dn string with different delimiter" do
    assert_equal 'C=JP/ST=Tokyo/L=Chiyoda-Ku/O=FirstOrg', @org_one.dn(delimiter: '/')
    assert_equal 'C=UK/ST=London/O=SecondOrg/OU=UnitName', @org_two.dn(delimiter: '/')
  end

  test "get entties array" do
    assert_equal [['C', 'JP'], ['ST', 'Tokyo'], ['L', 'Chiyoda-Ku'], ['O', 'FirstOrg']], @org_one.entries
  end
end
