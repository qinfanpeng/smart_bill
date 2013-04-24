class GoodNamesController < ApplicationController
  before_filter :require_admin, only: [:new, :create, :edit, :update, :destroy]
  respond_to :html, :json
  def names
    @names = GoodName.where('name like ?', "%#{params[:q]}%")
    render json: @names, only: [:name, :id]
  end

  def index
    @good_names = GoodName.paginate(page: params[:page], per_page: 10)
    respond_with @good_names
  end

  def show
    @good_name = GoodName.find(params[:id])
    respond_with @good_name
  end

  def edit
    @good_name = GoodName.find(params[:id])
    respond_with @good_name
  end

  def new
    @good_name = GoodName.new
    respond_with @good_name
  end

  def create
    @good_name = GoodName.new(params[:good_name])
    respond_with(@good_name) do |format|
      if @good_name.save
        flash[:success] = t('controllers.good_name.flashs.create.success')
      else
        flash[:error] = t('controllers.good_name.flashs.create.error')
      end
    end
  end

  def update
    @good_name = GoodName.find(params[:id])
    respond_with(@good_name) do |format|
      if @good_name.update_attributes(params[:good_name])
        flash[:success] = t('controllers.good_name.flashs.update.success')
      else
        flash[:error] = t('controllers.good_name.flashs.update.error')
      end
    end
  end

  def destroy
    @good_name = GoodName.find(params[:id])
    @good_name.destroy
    flash[:success] = t('controllers.good_name.flashs.destroy.success')
    respond_with @good_name
  end
end
