class UsersController < ApplicationController
  before_filter :require_admin, only: [:index, :new, :create, :destroy]
  before_filter :not_the_admin, only: [:destroy]
  before_filter :require_self, only: [:edit, :update]
  respond_to :html, :json

  def index
    @users = User.paginate(page: params[:page], per_page: 10)
    respond_with @users
  end

  def new
    @user = User.new
    respond_with @user
  end

  def create
    @user = User.new(params[:user])
    respond_with @users do |format|
      if @user.save
        flash[:success] = t('controllers.user.flashs.create.success')
        format.html { redirect_to users_url }
      else
        flash[:error] = t('controllers.user.flashs.create.error')
      end
    end
  end

  def edit
    respond_with @user
  end

  def update
    respond_with @user do |format|
      if @user.update_attributes(params[:user])
        flash[:success] = t('controllers.user.flashs.update.success')
      else
        flash[:error] = t('controllers.user.flashs.update.success')
      end
    end
  end

  def show
    @user = User.find(params[:id])
    respond_with(@user)
  end

  def destroy
    @user.destroy
    flash[:success] = t('controllers.user.flashs.destroy.success')
    respond_with @user
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
