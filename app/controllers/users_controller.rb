class UsersController < ApplicationController
  before_filter :require_admin, only: [:index, :new, :create, :destroy]
  before_filter :not_the_admin, only: [:destroy]
  before_filter :require_self, only: [:edit, :update]
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

  end

  def update
    if @user.update_attributes(params[:user])
      flash[:success] = t('controllers.user.flashs.update.success')
      redirect_to @user
    else
      flash[:error] = t('controllers.user.flashs.update.success')
      render :edit
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def destroy
    # @user = User.find(params[:id])
    @user.destroy
    flash[:success] = t('controllers.user.flashs.destroy.success')
    redirect_to users_url
  end

  private

  def not_the_admin
    @user = User.find(params[:id])
    if @user.admin?
      flash[:error] = t('controllers.not_the_admin')
      redirect_to users_url
    end
  end
  def require_self
    @user = User.find(params[:id])
    unless current_user.admin?
      unless @user.id == current_user.id
        flash[:error] = t('controllers.require_self')
        redirect_to root_url
      end
    end
  end

end
