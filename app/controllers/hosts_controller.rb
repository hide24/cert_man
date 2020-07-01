class HostsController < ApplicationController
  load_and_authorize_resource
  before_action :set_host, only: [:show, :edit, :update, :destroy]

  # GET /hosts
  # GET /hosts.json
  def index
    @hosts = Host.order(:id)
    if params[:query].present?
      @hosts = @hosts.where('hostname like ?', '%' + params[:query] + '%')
    end
  end

  # GET /hosts/1
  # GET /hosts/1.json
  def show
  end

  # GET /hosts/new
  def new
    @host = Host.new
  end

  # GET /hosts/1/edit
  def edit
  end

  # POST /hosts
  # POST /hosts.json
  def create
    @host = Host.new(host_params)

    respond_to do |format|
      if @host.save
        format.html { redirect_to @host, notice: 'Host was successfully created.' }
        format.json { render :show, status: :created, location: @host }
      else
        format.html { render :new }
        format.json { render json: @host.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /hosts/1
  # PATCH/PUT /hosts/1.json
  def update
    respond_to do |format|
      if @host.update(host_params)
        format.html { redirect_to @host, notice: 'Host was successfully updated.' }
        format.json { render :show, status: :ok, location: @host }
      else
        format.html { render :edit }
        format.json { render json: @host.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /hosts/1
  # DELETE /hosts/1.json
  def destroy
    @host.destroy
    respond_to do |format|
      format.html { redirect_to hosts_url, notice: 'Host was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # GET /hosts/schema
  def schema
    readonly = (params[:readonly] == "true")
    organizations = Organization.all.map do |o|
      {id: o.id, name: o.name}
    end
    host_schema = {
      groups: [
        {
          legend: 'Host Info',
          fields: [
            {
              type: "input",
              inputType: "text",
              label: "HostName",
              model: "hostname",
              inputName: "hostname",
              readonly: readonly,
              featured: true,
              required: true,
              disabled: false,
              validator: "string"
            },
            {
              type: "select",
              label: "Organization",
              model: "organization_id",
              inputName: "organization_id",
              readonly: readonly,
              featured: true,
              required: true,
              disabled: false,
              validator: "required",
              values: organizations,
              selectOptions: {
                noneSelectedText: "Select Organization",
              }
            },
          ]
        },
        {
          legend: 'Owner Info',
          fields: [
            {
              type: "input",
              inputType: "text",
              label: "Name",
              model: "owner_name",
              inputName: "owner_name",
              readonly: readonly,
              featured: true,
              required: true,
              disabled: false,
              placeholder: "",
              validator: "string"
            }, {
              type: "input",
              inputType: "text",
              label: "Mail",
              model: "mail",
              inputName: "mail",
              readonly: readonly,
              featured: true,
              required: true,
              disabled: false,
              placeholder: "",
              validator: "email"
            },
          ]
        }
      ]
    }

    render json: host_schema
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_host
      @host = Host.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def host_params
      params.require(:host).permit(:hostname, :organization_id, :owner_name, :mail)
    end
end
