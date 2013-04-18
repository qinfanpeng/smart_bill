class GoodNamesController < ApplicationController
  before_filter :require_admin, only: [:new, :create, :edit, :update, :destroy]
  def names
    @names = GoodName.where('name like ?', "%#{params[:q]}%")
    render json: @names, only: [:name, :id]
  end

  def index
    @good_names = GoodName.all
  end

  def show
    @good_name = GoodName.find(params[:id])
  end

  def edit
    @good_name = GoodName.find(params[:id])
  end

  def new
    @good_name = GoodName.new
  end

  def create
    @good_name = GoodName.new(params[:good_name])
    if @good_name.save
      flash[:success] = t('controllers.good_name.flashs.create.success')
      redirect_to good_names_path
    else
      flash[:error] = t('controllers.good_name.flashs.create.error')
      render :new
    end
  end

  def update
    @good_name = GoodName.find(params[:id])
    if @good_name.update_attributes(params[:good_name])
      flash[:success] = t('controllers.good_name.flashs.update.success')
      redirect_to @good_name
    else
      flash[:error] = t('controllers.good_name.flashs.update.error')
      redirect_to action: :edit
    end
  end

  def destroy
    @good_name = GoodName.find(params[:id])
    @good_name.destroy
    flash[:success] = t('controllers.good_name.flashs.destroy.success')
    respond_to do |format|
      format.html { redirect_to good_names_url }
      format.json { head :no_content }
    end
  end






end
