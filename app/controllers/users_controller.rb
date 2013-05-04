# -*- coding: utf-8 -*-
require 'pry'
class UsersController < ApplicationController
  before_filter :require_admin, only: [:index, :new, :create, :destroy]
  before_filter :not_the_admin, only: [:destroy]
  before_filter :require_self, only: [:edit, :update, :edit_email, :update_email, :edit_password, :update_password]
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
    respond_with @user do |format|
      if @user.save
        flash[:success] = t('controllers.user.flashs.create.success')
        format.html { redirect_to users_url }
      else
        flash[:error] = t('controllers.user.flashs.create.error')
      end
    end
  end
=begin
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
=end
  def show
    @user = User.find(params[:id])
    respond_with(@user)
  end

  def destroy
    @user.destroy
    flash[:success] = t('controllers.user.flashs.destroy.success')
    respond_with @user
  end

  def edit_email
  end

  def edit_password
  end

  def update_email
    @user.update_attribute(:email, params[:user][:email])
    @user.valid?   # 必须先检查有效性后, 才可以查看错误消息
    unless @user.errors[:email].any?  # 因为使用hase_secur_password 的缘故, @user.errors[:password].any 一直为真的, 所有直接检查email
      flash[:success] = t('controllers.user.flashs.update_email.success')
      redirect_to @user
    else
      flash[:error] = t('controllers.user.flashs.update_email.error')
      redirect_to edit_email_user_path(@user)
    end
  end

  def update_password
    #pry.binding
    if @user && @user.authenticate(params[:old_password])
      if @user.update_attribute(:password, params[:user][:password])
        flash[:success] = t('controllers.user.flashs.update_password.success')
        redirect_to @user
      else
        flash[:error] = t('controllers.user.flashs.update_password.error')
        redirect_to edit_password_user_path(@user)
      end
    else
      flash[:error] = t('controllers.user.flashs.update_password.not_correct_error')
      redirect_to edit_password_user_path(@user)
    end
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
    #unless current_user.admin?
      unless @user.id == current_user.id
        flash[:error] = t('controllers.require_self')
        redirect_to root_url
      end
    #end
  end

end
