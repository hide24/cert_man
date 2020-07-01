require 'test_helper'

class CertificateApplicationsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  setup do
    @certificate_application = certificate_applications(:one)
    @user = users(:one)
    sign_in(@user)
    @organization = organizations(:one)
    @host = hosts(:one)
    @host.organization = @organization
    @host.save
    @certificate = certificates(:one)
    @certificate.host = @host
    @certificate.save
    @certificate_application.certificates << @certificate
    @certificate_application.user = @user
    @certificate_application.save
  end

  test "should get index" do
    get certificate_applications_url
    assert_response :success
  end

  test "should get new" do
    get new_certificate_application_url
    assert_response :success
  end

  test "should create certificate_application" do
    assert_difference('CertificateApplication.count') do
      post certificate_applications_url, params: { certificate_application: { finished: @certificate_application.finished, user_id: @user.id } }
    end

    assert_redirected_to certificate_application_url(CertificateApplication.last)
  end

  test "should create certificate_application with host_ids" do
    assert_difference('CertificateApplication.count') do
      post certificate_applications_url, params: { certificate_application: { finished: @certificate_application.finished, user_id: @user.id, host_id: [@host.id] } }
    end

    assert_redirected_to certificate_application_url(CertificateApplication.last)
  end

  test "should show certificate_application" do
    get certificate_application_url(@certificate_application)
    assert_response :success
  end

  test "should get edit" do
    get edit_certificate_application_url(@certificate_application)
    assert_response :success
  end

  test "should update certificate_application" do
    patch certificate_application_url(@certificate_application), params: { certificate_application: { finished: @certificate_application.finished, user_id: @user.id } }
    assert_redirected_to certificate_application_url(@certificate_application)
  end

  test "should destroy certificate_application" do
    assert_difference('CertificateApplication.count', -1) do
      delete certificate_application_url(@certificate_application)
    end

    assert_redirected_to certificate_applications_url
  end

  test "should check uploaded file" do
    post upload_certificate_application_url(@certificate_application), params: { certificate_application: {file: [fixture_file_upload('files/one.cer')]} }
    assert_response :success
  end

  test "should check uploaded file(json)" do
    post upload_certificate_application_url(@certificate_application), 
      params: { certificate_application: {file: [fixture_file_upload('files/one.cer'), fixture_file_upload('files/invalid.cer')]}, format: 'json' }
    assert_equal (file_fixture('upload_result.json').read % @certificate.id), @response.body
  end
end
