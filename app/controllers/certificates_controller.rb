class CertificatesController < ApplicationController
  authorize_resource
  before_action :set_certificate, only: [:show, :edit, :update, :destroy]

  # GET /hosts/:host_id/certificates
  # GET /hosts/:host_id/certificates.json
  def index
    @host = Host.find(params[:host_id])
    @certificates = Certificate.where(host_id: @host).order('version DESC')
  end

  # GET /certificates/1
  # GET /certificates/1.json
  def show
    respond_to do |format|
      format.html
      format.json
      format.key {send_data(@certificate.certificate_key.to_s, filename: @certificate.hostname + '.key', disposition: 'attachment')}
      format.csr {send_data(@certificate.certificate_request.to_s, filename: @certificate.hostname + '.csr', disposition: 'attachment')}
      format.cer {send_data(@certificate.certificate.to_s, filename: @certificate.hostname + '.cer', disposition: 'attachment')}
    end
  end

  # GET /hosts/:host_id/certificates/new
  def new
    @host = Host.find(params[:host_id])
    @certificate = Certificate.new(host_id: @host)
  end

  # GET /certificates/1/edit
  def edit
  end

  # POST /hosts/:host_id/certificates
  # POST /hosts/:host_id/certificates.json
  def create
    @host = Host.find(params[:host_id])
    @certificate = Certificate.new(certificate_params)
    @certificate.host = @host

    respond_to do |format|
      if @certificate.save
        format.html { redirect_to @certificate, notice: 'Certificate was successfully created.' }
        format.json { render :show, status: :created, location: @certificate }
      else
        logger.info(@certificate.errors.full_messages)
        format.html { render :new }
        format.json { render json: @certificate.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /certificates/1
  # PATCH/PUT /certificates/1.json
  def update
    respond_to do |format|
      if @certificate.update(certificate_params)
        format.html { redirect_to @certificate, notice: 'Certificate was successfully updated.' }
        format.json { render :show, status: :ok, location: @certificate }
      else
        format.html { render :edit }
        format.json { render json: @certificate.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /certificates/1
  # DELETE /certificates/1.json
  def destroy
    @certificate.destroy
    respond_to do |format|
      format.html { redirect_to host_certificates_url(@certificate.host), notice: 'Certificate was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_certificate
      @certificate = Certificate.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def certificate_params
      params.require(:certificate).permit(:certificate)
    end
end
