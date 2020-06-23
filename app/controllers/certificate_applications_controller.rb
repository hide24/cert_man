class CertificateApplicationsController < ApplicationController
  before_action :set_certificate_application, only: [:show, :edit, :update, :destroy, :certificates]

  # GET /certificate_applications
  # GET /certificate_applications.json
  def index
    @certificate_applications = CertificateApplication.order('created_at DESC')
  end

  # GET /certificate_applications/1
  # GET /certificate_applications/1.json
  def show
  end

  # GET /certificate_applications/new
  def new
    @certificate_application = CertificateApplication.new
  end

  # GET /certificate_applications/1/edit
  def edit
  end

  # POST /certificate_applications
  # POST /certificate_applications.json
  def create
    @certificate_application = CertificateApplication.new(certificate_application_params)
    if certificate_application_params.key?(:host_id)
      @certificate_application.register(certificate_application_params[:host_id])
    end

    respond_to do |format|
      if @certificate_application.save
        format.html { redirect_to @certificate_application, notice: 'Certificate application was successfully created.' }
        format.json { render :show, status: :created, location: @certificate_application }
      else
        format.html { render :new }
        format.json { render json: @certificate_application.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /certificate_applications/1
  # PATCH/PUT /certificate_applications/1.json
  def update
    respond_to do |format|
      if @certificate_application.update(certificate_application_params)
        format.html { redirect_to @certificate_application, notice: 'Certificate application was successfully updated.' }
        format.json { render :show, status: :ok, location: @certificate_application }
      else
        format.html { render :edit }
        format.json { render json: @certificate_application.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /certificate_applications/1
  # DELETE /certificate_applications/1.json
  def destroy
    @certificate_application.destroy
    respond_to do |format|
      format.html { redirect_to certificate_applications_url, notice: 'Certificate application was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # GET /certificate_applications/1/certificates
  # GET /certificate_applications/1/certificates.json
  def certificates
    @certificates = @certificate_application.certificates
    render 'certificates/index'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_certificate_application
      @certificate_application = CertificateApplication.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def certificate_application_params
      params.require(:certificate_application).permit(:user_id, :finished, host_id: [])
    end
end
