class SessionsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    user = User.authenticate(params[:user])
    remember_me = !params[:remember_me].nil?
    if user
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
