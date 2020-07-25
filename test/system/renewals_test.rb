require "application_system_test_case"

class RenewalsTest < ApplicationSystemTestCase
  setup do
    @renewal = renewals(:one)
  end

  test "visiting the index" do
    visit renewals_url
    assert_selector "h1", text: "Renewals"
  end

  test "creating a Renewal" do
    visit renewals_url
    click_on "New Renewal"

    fill_in "Cer filename", with: @renewal.cer_filename
    fill_in "File host", with: @renewal.file_host
    fill_in "File password", with: @renewal.file_password
    fill_in "File path", with: @renewal.file_path
    fill_in "File pkey", with: @renewal.file_pkey
    check "File use password" if @renewal.file_use_password
    fill_in "File username", with: @renewal.file_username
    fill_in "Host", with: @renewal.host_id
    fill_in "Key filename", with: @renewal.key_filename
    fill_in "Script host", with: @renewal.script_host
    fill_in "Script password", with: @renewal.script_password
    fill_in "Script path", with: @renewal.script_path
    fill_in "Script pkey", with: @renewal.script_pkey
    check "Script use password" if @renewal.script_use_password
    fill_in "Script username", with: @renewal.script_username
    click_on "Create Renewal"

    assert_text "Renewal was successfully created"
    click_on "Back"
  end

  test "updating a Renewal" do
    visit renewals_url
    click_on "Edit", match: :first

    fill_in "Cer filename", with: @renewal.cer_filename
    fill_in "File host", with: @renewal.file_host
    fill_in "File password", with: @renewal.file_password
    fill_in "File path", with: @renewal.file_path
    fill_in "File pkey", with: @renewal.file_pkey
    check "File use password" if @renewal.file_use_password
    fill_in "File username", with: @renewal.file_username
    fill_in "Host", with: @renewal.host_id
    fill_in "Key filename", with: @renewal.key_filename
    fill_in "Script host", with: @renewal.script_host
    fill_in "Script password", with: @renewal.script_password
    fill_in "Script path", with: @renewal.script_path
    fill_in "Script pkey", with: @renewal.script_pkey
    check "Script use password" if @renewal.script_use_password
    fill_in "Script username", with: @renewal.script_username
    click_on "Update Renewal"

    assert_text "Renewal was successfully updated"
    click_on "Back"
  end

  test "destroying a Renewal" do
    visit renewals_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Renewal was successfully destroyed"
  end
end
