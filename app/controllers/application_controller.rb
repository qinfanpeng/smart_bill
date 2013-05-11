class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper
  before_filter :require_sign_in

  private
    def require_sign_in
      unless signed_in?
        flash[:notice] = t('controllers.require_sign_in')
        redirect_to signin_url
      end
    end

    def require_admin
      unless current_user.admin?
        flash[:error] = t('controllers.require_admin')
        redirect_to root_url
      end
    end

    def prepare_page_data
      @page = params[:page]
    end
end
