class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper

  private
    def require_sign_in
      unless signed_in?
        flash[:notice] = t('controllers.require_sign_in')
        redirect_to signin_url
      end
    end




end
