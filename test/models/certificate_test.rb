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

  test "should validate certificate" do
    @valid_cert1 = certificates(:one)
    @valid_cert2 = certificates(:two)
    @invalid_cert = certificates(:three)
    
    @valid_cert1.validate_certificate
    @valid_cert2.validate_certificate
    @invalid_cert.validate_certificate
    assert_equal [], @valid_cert1.errors.full_messages
    assert_equal [], @valid_cert2.errors.full_messages
    assert_equal ["Certificate certificate should be X509 certificate."], @invalid_cert.errors.full_messages
  end

  test "should return tsv format" do
    tsv_value = "CN=example1.com,O=FirstOrg,L=Chiyoda-Ku,ST=Tokyo,C=JP\t3\t\t\t\t\tMIICoDCCAYgCAQAwWzELMAkGA1UEBhMCSlAxDjAMBgNVBAgMBVRva3lvMRMwEQYDVQQHDApDaGl5b2RhLUt1MREwDwYDVQQKDAhGaXJzdE9yZzEUMBIGA1UEAwwLZXhhbXBsZS5jb20wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDe+hM+jEPv7ogRqmpoEV2OJGtaRR+oHL95MBmFA2z4kKvW6xNWknj16J2gPIP1rZjq4PB1ML32rcqabWNyJZq761KVR4H3aXEeXSaxf9/PWCPkOTwrSfvzHz7HjS2aw4la2pe5lUaMrxL5THppuhNdS+ZFKysrtJC7uyldQrIYb2OxvWKHLwfYlTdiN9IfM8hawGU0/FyWnRjKVWrMF1e9sBFMGYDRmHLdN/lc6gUQVfnIEyZCCbsFHIzw9QttDhRMWIPvGhEpH8ujhKBJQ0iXIHi/3k1FTvrpl4A2LpwMtGkYW9N6DmSoz2VV41o/mFCww2e+OO4YeQs6Gpz++J9JAgMBAAGgADANBgkqhkiG9w0BAQsFAAOCAQEAiP2cHo75aW7ZfqZP/O61ut65oBRRF57gv5KYU+Qz0QWgDSiumhjGdcGB12vtcXp13Z0F7XNzThIVaZf3UsLA/wwVcCRYHHnw4+GDqg5eIsx/9qjVPenzIvfex4MvTYW95fc+RIzrBi70UuigpokB/wXUlz9nbQ55gPUz6Xh2UbNIGHvs1PYC1CfMcQCINog5qywu1gKEzbr55fCtf5ySYT2/bjbD8E4w0NdYLSChQzEgk7c0HKJHnk1HR5a7uO8rKOmu+Oir+9cPeFcUAK1LCO1J1APjy6ud1+/3EHaxYbRECXK7Wa/QCfC2ELhXH574vGQtVorLlmh12VCnzp3EPg==\towner1\tFirstOrg\towner1@example.com\texample1.com\tapache2.4\t"
    tsv_value2 = "CN=example1.com,O=FirstOrg,L=Chiyoda-Ku,ST=Tokyo,C=JP\t3\t\t17696094483674561855\t\t\tMIICoDCCAYgCAQAwWzELMAkGA1UEBhMCSlAxDjAMBgNVBAgMBVRva3lvMRMwEQYDVQQHDApDaGl5b2RhLUt1MREwDwYDVQQKDAhGaXJzdE9yZzEUMBIGA1UEAwwLZXhhbXBsZS5jb20wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDe+hM+jEPv7ogRqmpoEV2OJGtaRR+oHL95MBmFA2z4kKvW6xNWknj16J2gPIP1rZjq4PB1ML32rcqabWNyJZq761KVR4H3aXEeXSaxf9/PWCPkOTwrSfvzHz7HjS2aw4la2pe5lUaMrxL5THppuhNdS+ZFKysrtJC7uyldQrIYb2OxvWKHLwfYlTdiN9IfM8hawGU0/FyWnRjKVWrMF1e9sBFMGYDRmHLdN/lc6gUQVfnIEyZCCbsFHIzw9QttDhRMWIPvGhEpH8ujhKBJQ0iXIHi/3k1FTvrpl4A2LpwMtGkYW9N6DmSoz2VV41o/mFCww2e+OO4YeQs6Gpz++J9JAgMBAAGgADANBgkqhkiG9w0BAQsFAAOCAQEAiP2cHo75aW7ZfqZP/O61ut65oBRRF57gv5KYU+Qz0QWgDSiumhjGdcGB12vtcXp13Z0F7XNzThIVaZf3UsLA/wwVcCRYHHnw4+GDqg5eIsx/9qjVPenzIvfex4MvTYW95fc+RIzrBi70UuigpokB/wXUlz9nbQ55gPUz6Xh2UbNIGHvs1PYC1CfMcQCINog5qywu1gKEzbr55fCtf5ySYT2/bjbD8E4w0NdYLSChQzEgk7c0HKJHnk1HR5a7uO8rKOmu+Oir+9cPeFcUAK1LCO1J1APjy6ud1+/3EHaxYbRECXK7Wa/QCfC2ELhXH574vGQtVorLlmh12VCnzp3EPg==\towner1\tFirstOrg\towner1@example.com\texample1.com\tapache2.4\t"
    assert_equal tsv_value, @certificate.to_tsv
    @cert2 = certificates(:two)
    @cert2.host = @host
    assert_equal tsv_value2, @cert2.to_tsv
  end

  test "should return not_after" do
    @cert1 = certificates(:one)
    @cert2 = certificates(:two)
    @valid_to = Time.parse('2030-03-12 07:23:25 UTC')
    assert_equal false, @cert1.not_after
    assert_equal @valid_to, @cert2.not_after
  end

  test "should return not_before" do
    @cert1 = certificates(:one)
    @cert2 = certificates(:two)
    @valid_from = Time.parse('2020-06-12 07:23:25 UTC')
    assert_equal false, @cert1.not_before
    assert_equal @valid_from, @cert2.not_before
  end

  test "should check expiration(valid)" do
    @cert = certificates(:two)
    @valid_date = Time.parse('2020-07-12 07:23:25 UTC')
    Time.stub(:now, @valid_date) do
      assert_equal false, @cert.expired?
    end
  end

  test "should check expiration(expired)" do
    @cert = certificates(:two)
    @valid_date = Time.parse('2040-07-12 07:23:25 UTC')
    Time.stub(:now, @valid_date) do
      assert_equal true, @cert.expired?
    end
  end

  test "should check expiration(before)" do
    @cert = certificates(:two)
    @valid_date = Time.parse('2010-07-12 07:23:25 UTC')
    Time.stub(:now, @valid_date) do
      assert_equal true, @cert.expired?
    end
  end

  test "should check expiration(near)" do
    @cert = certificates(:two)
    @valid_date = Time.parse('2030-02-12 07:23:25 UTC')
    Time.stub(:now, @valid_date) do
      assert_equal true, @cert.near_expire?
    end
  end

  test "should get expiration date" do
    @cert1 = certificates(:one)
    @cert2 = certificates(:two)
    assert_equal 'no valid certificate', @cert1.expiration_date
    assert_equal '2020/06/12 - 2030/03/12', @cert2.expiration_date
  end

  test "should get expiration date class(valid)" do
    @cert = certificates(:two)
    @valid_date = Time.parse('2020-07-12 07:23:25 UTC')
    Time.stub(:now, @valid_date) do
      assert_equal 'success', @cert.expiration_date_class
    end
  end

  test "should get expiration date class(warn)" do
    @cert = certificates(:two)
    @valid_date = Time.parse('2030-02-12 07:23:25 UTC')
    Time.stub(:now, @valid_date) do
      assert_equal 'warning', @cert.expiration_date_class
    end
  end

  test "should get expiration date class(error)" do
    @cert = certificates(:two)
    @valid_date = Time.parse('2040-02-12 07:23:25 UTC')
    Time.stub(:now, @valid_date) do
      assert_equal 'danger', @cert.expiration_date_class
    end
  end
end
