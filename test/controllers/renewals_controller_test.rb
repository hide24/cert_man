require 'test_helper'

class RenewalsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  setup do
    @renewal = renewals(:one)
    @host = hosts(:one)
    @renewal.host = @host
    @renewal.save
    @user = users(:one)
    sign_in(@user)
  end

  test "should get index" do
    get host_renewal_url(@host)
    assert_response :success
  end

  test "should get new" do
    get new_host_renewal_url(@host)
    assert_response :success
  end

  test "should create renewal" do
    @renewal.delete
    assert_difference('Renewal.count') do
      post host_renewal_url(@host), params: { renewal: { cer_filename: @renewal.cer_filename, file_host: @renewal.file_host, file_password: @renewal.file_password, file_path: @renewal.file_path, file_pkey: @renewal.file_pkey, file_authtype: @renewal.file_authtype, file_username: @renewal.file_username, host_id: @renewal.host_id, key_filename: @renewal.key_filename, script_host: @renewal.script_host, script_password: @renewal.script_password, script_path: @renewal.script_path, script_pkey: @renewal.script_pkey, script_authtype: @renewal.script_authtype, script_username: @renewal.script_username } }
    end

    assert_redirected_to host_renewal_url(@host)
  end

  test "should not create renewal, when it was already exists" do
    assert_no_difference('Renewal.count') do
      post host_renewal_url(@host), params: { renewal: { cer_filename: @renewal.cer_filename, file_host: @renewal.file_host, file_password: @renewal.file_password, file_path: @renewal.file_path, file_pkey: @renewal.file_pkey, file_authtype: @renewal.file_authtype, file_username: @renewal.file_username, host_id: @renewal.host_id, key_filename: @renewal.key_filename, script_host: @renewal.script_host, script_password: @renewal.script_password, script_path: @renewal.script_path, script_pkey: @renewal.script_pkey, script_authtype: @renewal.script_authtype, script_username: @renewal.script_username } }
    end

    assert_redirected_to host_renewal_url(@host)
  end

  test "should show renewal" do
    get host_renewal_url(@host)
    assert_response :success
  end

  test "should get edit" do
    get edit_host_renewal_url(@host)
    assert_response :success
  end

  test "should update renewal" do
    patch host_renewal_url(@host), params: { renewal: { cer_filename: @renewal.cer_filename, file_host: @renewal.file_host, file_password: @renewal.file_password, file_path: @renewal.file_path, file_pkey: @renewal.file_pkey, file_authtype: @renewal.file_authtype, file_username: @renewal.file_username, host_id: @renewal.host_id, key_filename: @renewal.key_filename, script_host: @renewal.script_host, script_password: @renewal.script_password, script_path: @renewal.script_path, script_pkey: @renewal.script_pkey, script_authtype: @renewal.script_authtype, script_username: @renewal.script_username } }
    assert_redirected_to host_renewal_url(@host)
  end

  test "should destroy renewal" do
    assert_difference('Renewal.count', -1) do
      delete host_renewal_url(@host)
    end

    assert_redirected_to host_url(@host)
  end

  test "should get form schema" do
    @schema = file_fixture('renewal.schema.json').read
    get renewal_schema_url
    assert_equal @schema, response.body
  end
end
