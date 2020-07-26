class RenewalsController < ApplicationController
  load_and_authorize_resource
  before_action :set_host, except: [:schema]
  before_action :set_renewal, only: [:show, :edit, :update, :destroy, :create]

  # GET /hosts/1/renewals
  # GET /hosts/1/renewals.json
  def index
    @renewals = Renewal.all
  end

  # GET /hosts/1/renewal
  # GET /hosts/1/renewal.json
  def show
  end

  # GET /hosts/1/renewal/new
  def new
    @renewal = Renewal.new
  end

  # GET /hosts/1/renewals/edit
  def edit
  end

  # POST /hosts/1/renewal
  # POST /hosts/1/renewal.json
  def create
    if @renewal.present?
      update
      return
    end
    @renewal = Renewal.new(renewal_params)

    respond_to do |format|
      if @renewal.save
        format.html { redirect_to host_renewal_url(@host), notice: 'Renewal was successfully created.' }
        format.json { render :show, status: :created, location: @renewal }
      else
        format.html { render :new }
        format.json { render json: @renewal.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /hosts/1/renewal
  # PATCH/PUT /hosts/1/renewal.json
  def update
    respond_to do |format|
      if @renewal.update(renewal_params)
        format.html { redirect_to host_renewal_url(@host), notice: 'Renewal was successfully updated.' }
        format.json { render :show, status: :ok, location: @renewal }
      else
        format.html { render :edit }
        format.json { render json: @renewal.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /hosts/1/renewal
  # DELETE /hosts/1/renewal.json
  def destroy
    @renewal.destroy
    respond_to do |format|
      format.html { redirect_to @host, notice: 'Renewal was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # GET /renewal/schema
  def schema
    readonly = (params[:readonly] == "true")
    renewal_schema = {
      groups: [
        {
          legend: Renewal.human_attribute_name(:file_transfer_info),
          fields: [
            {
              type: "input",
              inputType: "text",
              label: Renewal.human_attribute_name(:file_host),
              model: "file_host",
              inputName: "file_host",
              readonly: readonly,
              featured: true,
              required: true,
              disabled: false,
              validator: "string"
            },
            {
              type: "input",
              inputType: "text",
              label: Renewal.human_attribute_name(:file_path),
              model: "file_path",
              inputName: "file_path",
              readonly: readonly,
              featured: true,
              required: true,
              disabled: false,
              validator: "string"
            },
            {
              type: "input",
              inputType: "text",
              label: Renewal.human_attribute_name(:cer_filename),
              model: "cer_filename",
              inputName: "cer_filename",
              readonly: readonly,
              featured: true,
              required: true,
              disabled: false,
              validator: "string"
            },
            {
              type: "input",
              inputType: "text",
              label: Renewal.human_attribute_name(:key_filename),
              model: "key_filename",
              inputName: "key_filename",
              readonly: readonly,
              featured: true,
              required: true,
              disabled: false,
              validator: "string"
            },
            {
              type: "input",
              inputType: "text",
              label: Renewal.human_attribute_name(:file_username),
              model: "file_username",
              inputName: "file_username",
              readonly: readonly,
              featured: true,
              required: true,
              disabled: false,
              validator: "string"
            },
            {
              type: "input",
              inputType: "password",
              label: Renewal.human_attribute_name(:file_password),
              model: "file_password",
              inputName: "file_password",
              readonly: readonly,
              featured: true,
              required: true,
              disabled: false,
              validator: "string"
            },
            {
              type: "input",
              inputType: "text",
              label: Renewal.human_attribute_name(:file_pkey),
              model: "file_pkey",
              inputName: "file_pkey",
              readonly: readonly,
              featured: true,
              required: true,
              disabled: false,
              validator: "string"
            },
            {
              type: "switch",
              label: Renewal.human_attribute_name(:file_authtype),
              model: "file_authtype",
              readonly: readonly,
              featured: true,
              disabled: true,
              default: true,
              textOn: Renewal.human_attribute_name(:pkey_auth),
              textOff: Renewal.human_attribute_name(:password_auth)
            },
          ]
        },
        {
          legend: Renewal.human_attribute_name(:script_execute_info),
          fields: [
            {
              type: "input",
              inputType: "text",
              label: Renewal.human_attribute_name(:script_host),
              model: "script_host",
              inputName: "script_host",
              readonly: readonly,
              featured: true,
              required: true,
              disabled: false,
              validator: "string"
            },
            {
              type: "input",
              inputType: "text",
              label: Renewal.human_attribute_name(:script_path),
              model: "script_path",
              inputName: "script_path",
              readonly: readonly,
              featured: true,
              required: true,
              disabled: false,
              validator: "string"
            },
            {
              type: "input",
              inputType: "text",
              label: Renewal.human_attribute_name(:script_username),
              model: "script_username",
              inputName: "script_username",
              readonly: readonly,
              featured: true,
              required: true,
              disabled: false,
              validator: "string"
            },
            {
              type: "input",
              inputType: "password",
              label: Renewal.human_attribute_name(:script_password),
              model: "script_password",
              inputName: "script_password",
              readonly: readonly,
              featured: true,
              required: true,
              disabled: false,
              validator: "string"
            },
            {
              type: "input",
              inputType: "text",
              label: Renewal.human_attribute_name(:script_pkey),
              model: "script_pkey",
              inputName: "script_pkey",
              readonly: readonly,
              featured: true,
              required: true,
              disabled: false,
              validator: "string"
            },
            {
              type: "switch",
              label: Renewal.human_attribute_name(:script_authtype),
              model: "script_authtype",
              readonly: readonly,
              featured: true,
              disabled: true,
              default: true,
              textOn: Renewal.human_attribute_name(:pkey_auth),
              textOff: Renewal.human_attribute_name(:password_auth)
            },
          ]
        },
      ]
    }

    render json: renewal_schema
  end

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_renewal
      @host ||= Host.find(params[:host_id])
      @renewal = @host.renewal
    end

    def set_host
      @host = Host.find(params[:host_id])
    end

    # Only allow a list of trusted parameters through.
    def renewal_params
      params.require(:renewal).permit(:host_id, :file_host, :file_path, :cer_filename, :key_filename, :file_username, :file_password, :file_pkey, :file_authtype, :script_host, :script_path, :script_username, :script_password, :script_pkey, :script_authtype)
    end
end
