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




end
