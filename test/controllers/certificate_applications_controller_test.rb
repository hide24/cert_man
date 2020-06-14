require 'test_helper'

class CertificateApplicationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @certificate_application = certificate_applications(:one)
    @user = users(:one)
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
end
