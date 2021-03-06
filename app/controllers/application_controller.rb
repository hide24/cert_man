class ApplicationController < ActionController::Base
  around_action :switch_locale
  before_action :authenticate_user!
  check_authorization unless: :skip_checking_authorzation?
  rescue_from CanCan::AccessDenied, with: :handle_access_denied

  private
  def skip_checking_authorzation?
    devise_controller?
  end  

  def handle_access_denied(exception)
    respond_to do |format|
      format.json { head :forbidden, content_type: 'text/html' }
      format.html { redirect_to main_app.root_url, notice: exception.message }
      format.js   { head :forbidden, content_type: 'text/html' }
    end
  end

  def switch_locale(&action)
    locale = params[:locale] || I18n.default_locale
    I18n.with_locale(locale, &action)
  end
end
