class OrganizationsController < ApplicationController
  before_action :set_organization, only: [:show, :edit, :update, :destroy, :dup]

  # GET /organizations
  # GET /organizations.json
  def index
    @organizations = Organization.order(:id)
    if params[:query].present?
      @organizations = @organizations.where('name like ?', '%' + params[:query] + '%')
    end
  end

  # GET /organizations/1
  # GET /organizations/1.json
  def show
  end

  # GET /organizations/new
  def new
    @organization = Organization.new
  end

  # GET /organizations/1/edit
  def edit
  end

  # POST /organizations
  # POST /organizations.json
  def create
    @organization = Organization.new(organization_params)

    respond_to do |format|
      if @organization.save
        format.html { redirect_to @organization, notice: 'Organization was successfully created.' }
        format.json { render :show, status: :created, location: @organization }
      else
        format.html { render :new }
        format.json { render json: @organization.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /organizations/1
  # PATCH/PUT /organizations/1.json
  def update
    respond_to do |format|
      if @organization.update(organization_params)
        format.html { redirect_to @organization, notice: 'Organization was successfully updated.' }
        format.json { render :show, status: :ok, location: @organization }
      else
        format.html { render :edit }
        format.json { render json: @organization.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /organizations/1
  # DELETE /organizations/1.json
  def destroy
    @organization.destroy
    respond_to do |format|
      format.html { redirect_to organizations_url, notice: 'Organization was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # GET /organization/1/dup
  def dup
    render action: 'new'
  end

  # GET /organization/schema
  def schema
    readonly = (params[:readonly] == "true")
    organization_schema = {
      groups: [
        {
          legend: 'Organization Info',
          fields: [
            {
              type: "input",
              inputType: "text",
              label: "Name",
              model: "organization.name",
              inputName: "organization[name]",
              readonly: readonly,
              featured: true,
              required: true,
              disabled: false,
              validator: "string"
            },
          ]
        },
        {
          legend: 'Domain Name Info',
          fields: [
            {
              type: "input",
              inputType: "text",
              label: "Country",
              model: "organization.country",
              inputName: "organization[country]",
              readonly: readonly,
              featured: true,
              required: true,
              disabled: false,
              placeholder: "",
              validator: "string"
            }, {
              type: "input",
              inputType: "text",
              label: "state",
              model: "organization.state",
              inputName: "organization[state]",
              readonly: readonly,
              featured: true,
              required: true,
              disabled: false,
              placeholder: "",
              validator: "string"
            }, {
              type: "input",
              inputType: "text",
              label: "locality",
              model: "organization.locality",
              inputName: "organization[locality]",
              readonly: readonly,
              featured: true,
              required: true,
              disabled: false,
              placeholder: "",
              validator: "string"
            }, {
              type: "input",
              inputType: "text",
              label: "Organization",
              model: "organization.organization",
              inputName: "organizationorganization",
              readonly: readonly,
              featured: true,
              required: true,
              disabled: false,
              placeholder: "",
              validator: "string"
            }, {
              type: "input",
              inputType: "text",
              label: "Organizational Unit",
              model: "organization.unit",
              inputName: "organization[unit]",
              readonly: readonly,
              featured: true,
              required: false,
              disabled: false,
              placeholder: "",
              validator: "string"
            }, {
              type: "input",
              inputType: "text",
              label: "Mail",
              model: "organization.mail",
              inputName: "organization[mail]",
              readonly: readonly,
              featured: true,
              required: false,
              disabled: false,
              placeholder: "",
              validator: "string"
            }
          ],
        },
      ]
    }

    render json: organization_schema
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_organization
      @organization = Organization.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def organization_params
      params.require(:organization).permit(:name, :country, :state, :locality, :organization, :unit, :mail)
    end
end
