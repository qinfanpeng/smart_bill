# -*- coding: utf-8 -*-
module SessionsHelper
  def signin user
    cookies.permanent[:user_id] = user.id
    self.current_user = user
  end

  def current_user
    @current_user ||= User.find_by_id(cookies[:user_id])
  end

  def current_user=(user)
    @current_user = user
  end

  def signout
    cookies[:user_id] = nil
    @current_user = nil
  end

  def signed_in?
    # !@current_user.nil?  此法行不通
    !current_user.nil?
  end

end
