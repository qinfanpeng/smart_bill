# -*- coding: utf-8 -*-
module SessionsHelper
  def signin(user, remember_me=false)
    if remember_me
      cookies.permanent[:user_id] = user.id
    else
      session[:user_id] = user.id
    end
    self.current_user = user
  end

  def current_user
    _user_id = session[:user_id] || cookies[:user_id] # 注意把session[:user_id]写在前面, 否则不 ‘记住我’ 就登录不进，目前不知何因
    @current_user ||= User.find_by_id(_user_id)
  end

  def current_user=(user)
    @current_user = user
  end

  def signout
    cookies[:user_id] = nil
    session[:user_id] = nil
    @current_user = nil
  end

  def signed_in?
    # !@current_user.nil?  此法行不通
    !current_user.nil?
  end

end
