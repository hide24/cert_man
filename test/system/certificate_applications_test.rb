require "application_system_test_case"

class CertificateApplicationsTest < ApplicationSystemTestCase
  setup do
    @certificate_application = certificate_applications(:one)
  end

  test "visiting the index" do
    visit certificate_applications_url
    assert_selector "h1", text: "Certificate Applications"
  end

  test "creating a Certificate application" do
    visit certificate_applications_url
    click_on "New Certificate Application"

    fill_in "Application type", with: @certificate_application.application_type
    fill_in "Status", with: @certificate_application.status
    fill_in "User", with: @certificate_application.user_id
    click_on "Create Certificate application"

    assert_text "Certificate application was successfully created"
    click_on "Back"
  end

  test "updating a Certificate application" do
    visit certificate_applications_url
    click_on "Edit", match: :first

    fill_in "Application type", with: @certificate_application.application_type
    fill_in "Status", with: @certificate_application.status
    fill_in "User", with: @certificate_application.user_id
    click_on "Update Certificate application"

    assert_text "Certificate application was successfully updated"
    click_on "Back"
  end

  test "destroying a Certificate application" do
    visit certificate_applications_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Certificate application was successfully destroyed"
  end
end
