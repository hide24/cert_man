class RenewalsController < ApplicationController
  load_and_authorize_resource
  before_action :set_host
  before_action :set_renewal, only: [:show, :edit, :update, :destroy]

  # GET /renewals
  # GET /renewals.json
  def index
    @renewals = Renewal.all
  end

  # GET /renewals/1
  # GET /renewals/1.json
  def show
  end

  # GET /renewals/new
  def new
    @renewal = Renewal.new
  end

  # GET /renewals/1/edit
  def edit
  end

  # POST /renewals
  # POST /renewals.json
  def create
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

  # PATCH/PUT /renewals/1
  # PATCH/PUT /renewals/1.json
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

  # DELETE /renewals/1
  # DELETE /renewals/1.json
  def destroy
    @renewal.destroy
    respond_to do |format|
      format.html { redirect_to @host, notice: 'Renewal was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_renewal
      @host ||= Host.find(params[:host_id])
      @renewal = @host.renewal #Renewal.find(params[:id])
    end

    def set_host
      @host = Host.find(params[:host_id])
    end

    # Only allow a list of trusted parameters through.
    def renewal_params
      params.require(:renewal).permit(:host_id, :file_host, :file_path, :cer_filename, :key_filename, :file_username, :file_password, :file_pkey, :file_use_password, :script_host, :script_path, :script_username, :script_password, :script_pkey, :script_use_password)
    end
end
