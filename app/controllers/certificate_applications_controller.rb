class CertificateApplicationsController < ApplicationController
  load_and_authorize_resource
  before_action :set_certificate_application, only: [:show, :edit, :update, :destroy, :certificates, :upload]

  # GET /certificate_applications
  # GET /certificate_applications.json
  def index
    if current_user.has_role?(:admin)
      @certificate_applications = CertificateApplication.order('created_at DESC')
    else
      @certificate_applications = current_user.certificate_applications.order('created_at DESC')
    end
  end

  # GET /certificate_applications/1
  # GET /certificate_applications/1.json
  def show
    respond_to do |format|
      format.html
      format.json
      format.tsv {send_data(@certificate_application.to_tsv, filename: @certificate_application.basename + '.tsv', disposition: 'attachment')}
      format.zip {send_data(@certificate_application.to_zip, filename: @certificate_application.basename + '.zip', disposition: 'attachment')}
    end
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
    @certificate_application.user = current_user
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

  # POST /certification_applications/1/upload
  def upload
#    @upload_files = certificate_upliad_params[:file]
    @upload_files = params[:certificate_application][:file]
    @checked_files = @upload_files.map do |file|
      filename = file.original_filename
      file_body = file.read(4096)
      check_result = @certificate_application.check_uploaded_file(file_body)
      {
        certificate_id: check_result[:certificate].try(:id),
        filename: filename,
        hostname: (check_result[:certificate].host.hostname rescue ''),
        subject: (check_result[:certificate].certificate_request.subject.to_s rescue ''),
        errors: check_result[:errors],
        status: check_result[:status],
        certificate: file_body,
      }
    end
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

    def certificate_upliad_params
      params.require(:certificate_application).permit(file: [])
    end
end
