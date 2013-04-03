class UsersController < ApplicationController

  def index
    @users = User.all
  end
  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:success] = t('controllers.user.flashs.create.success')
      redirect_to users_path
    else
      flash[:error] = t('controllers.user.flashs.create.error')
      render :new
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = t('controllers.user.flashs.update.success')
      redirect_to @user
    else
      flash[:erro] = t('controllers.user.flashs.update.success')
      render :edit
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    flash[:success] = t('controllers.user.flashs.destroy.success')
    redirect_to users_url
  end
end
