# -*- coding: utf-8 -*-
module SessionsHelper
  def signin(user, remember_me)
    if remember_me
      session[:user_id] = user.id
      #cookies.permanent[:user_id] = user.id
    else
      session[:user_id] = user.id
    end
    self.current_user = user
  end

  def current_user
    #_user_id = cookies[:user_id] || session[:user_id]
    @current_user ||= User.find_by_id(session[:user_id])
  end

  def current_user=(user)
    @current_user = user
  end

  def signout
    #cookies[:user_id] = nil
    session[:user_id] = nil
    @current_user = nil
  end

  def signed_in?
    # !@current_user.nil?  此法行不通
    !current_user.nil?
  end

end
