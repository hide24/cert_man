require 'test_helper'

class CertificatesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  setup do
    @certificate = certificates(:one)
    @host = hosts(:one)
    @organization = organizations(:one)
    @host.organization = @organization
    @host.save
    @certificate.host = @host
    @certificate.save
    @user = users(:one)
    sign_in(@user)
  end

  test "should get index" do
    get host_certificates_url(@host)
    assert_response :success
  end

  test "should get new" do
    get new_host_certificate_url(@host)
    assert_response :success
  end

  test "should create certificate" do
    assert_difference('Certificate.count') do
      post host_certificates_url(@host), params: { certificate: { certificate: @certificate.certificate, certificate_request: @certificate.certificate_request, certificate_key: @certificate.certificate_key, version: @certificate.version, host_id: @host.id } }
    end

    assert_redirected_to certificate_url(Certificate.last)
  end

  test "should show certificate" do
    get certificate_url(@certificate)
    assert_response :success
  end

  test "should get edit" do
    get edit_certificate_url(@certificate)
    assert_response :success
  end

  test "should update certificate" do
    patch certificate_url(@certificate), params: { certificate: { certificate: @certificate.certificate, certificate_request: @certificate.certificate_request, certificate_key: @certificate.certificate_key, version: @certificate.version, host_id: @host.id } }
    assert_redirected_to certificate_url(@certificate)
  end

  test "should destroy certificate" do
    assert_difference('Certificate.count', -1) do
      delete certificate_url(@certificate)
    end

    assert_redirected_to host_certificates_url(@host)
  end

  test "should return private key" do
    get certificate_url(@certificate, format: 'key')
    assert_match @certificate.certificate_key.to_s, @response.body
  end

  test "should return certificate request" do
    get certificate_url(@certificate, format: 'csr')
    assert_match @certificate.certificate_request.to_s, @response.body
  end

  test "should return certificate" do
    get certificate_url(@certificate, format: 'cer')
    assert_match @certificate.certificate.to_s, @response.body
  end
end
