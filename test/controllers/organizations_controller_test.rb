require 'test_helper'

class OrganizationsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  setup do
    @organization = organizations(:one)
    @user = users(:one)
    sign_in(@user)
  end

  test "should get index" do
    get organizations_url
    assert_response :success
  end

  test "should get new" do
    get new_organization_url
    assert_response :success
  end

  test "should create organization" do
    assert_difference('Organization.count') do
      post organizations_url, params: { organization: { country: @organization.country, locality: @organization.locality, mail: @organization.mail, name: @organization.name, organization: @organization.organization, state: @organization.state, unit: @organization.unit } }
    end

    assert_redirected_to organization_url(Organization.last)
  end

  test "should show organization" do
    get organization_url(@organization)
    assert_response :success
  end

  test "should get edit" do
    get edit_organization_url(@organization)
    assert_response :success
  end

  test "should update organization" do
    patch organization_url(@organization), params: { organization: { country: @organization.country, locality: @organization.locality, mail: @organization.mail, name: @organization.name, organization: @organization.organization, state: @organization.state, unit: @organization.unit } }
    assert_redirected_to organization_url(@organization)
  end

  test "should destroy organization" do
    assert_difference('Organization.count', -1) do
      delete organization_url(@organization)
    end

    assert_redirected_to organizations_url
  end

  test "should get duplicated form" do
    get dup_organization_url(@organization)
    assert_response :success
    assert_match 'FirstOrg', @response.body
  end

  test "should get form schema" do
    get schema_organizations_url
    assert_equal file_fixture('organization.schema.json').read, response.body
  end
end
