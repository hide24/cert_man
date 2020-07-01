require 'test_helper'

class HostsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  setup do
    @host = hosts(:one)
    @organization = organizations(:one)
    @user = users(:one)
    sign_in(@user)
  end

  test "should get index" do
    get hosts_url
    assert_response :success
  end

  test "should get new" do
    get new_host_url
    assert_response :success
  end

  test "should create host" do
    assert_difference('Host.count') do
      post hosts_url, params: { host: { hostname: 'another.example.com', organization_id: @organization.id } }
    end

    assert_redirected_to host_url(Host.last)
  end

  test "should show host" do
    get host_url(@host)
    assert_response :success
  end

  test "should get edit" do
    get edit_host_url(@host)
    assert_response :success
  end

  test "should update host" do
    patch host_url(@host), params: { host: { hostname: @host.hostname, organization_id: @organization.id  } }
    assert_redirected_to host_url(@host)
  end

  test "should destroy host" do
    assert_difference('Host.count', -1) do
      delete host_url(@host)
    end

    assert_redirected_to hosts_url
  end

  test "should get form schema" do
    @host2 = hosts(:two)
    @schema = file_fixture('host.schema.json').read % [@host.id, @host2.id]
    get schema_hosts_url
    assert_equal @schema, response.body
  end
end
