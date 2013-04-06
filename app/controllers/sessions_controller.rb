class SessionsController < ApplicationController
  skip_before_filter :require_sign_in
  def new
    @user = User.new
  end

  def create
    user = User.find_by_name(params[:user][:name])
    remember_me = !params[:remember_me].nil?
    if user && user.authenticate(params[:user][:password])
      signin(user, remember_me)
      flash[:success] = t('controllers.session.flashs.create.success')
      redirect_to root_url
    else
      flash[:error] = t('controllers.session.flashs.create.error')
      redirect_to signin_url
    end
  end

  def destroy
    signout
    flash[:success] = t('controllers.session.flashs.destroy.success')
    redirect_to signin_url
  end

end
