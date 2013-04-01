class BillsController < ApplicationController
  before_filter :require_sign_in
  before_filter :require_creater, only: [:destroy, :update, :edit]

  def index
    @bills = Bill.all
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @bills }
    end
  end

  def show
    @bill = Bill.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @bill }
    end
  end

  def new
    @bill = Bill.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @bill }
    end
  end


  def edit
    @bill = Bill.find(params[:id])
  end

  def create
    @bill = current_user.bills.build(params[:bill])

    respond_to do |format|
      if @bill.save
        flash[:success] = t('controllers.bill.flashs.create.success')
        format.html { redirect_to @bill }
        format.json { render json: @bill, status: :created, location: @bill }
      else
        flash[:error] = t('controllers.bill.flashs.update.error')
        format.html { render action: "new" }
        format.json { render json: @bill.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @bill = Bill.find(params[:id])

    respond_to do |format|
      if @bill.update_attributes(params[:bill])
        flash[:success] = t('controllers.bill.flashs.update.success')
        format.html { redirect_to @bill }
        format.json { head :no_content }
      else
        flash[:error] = t('controllers.bill.flashs.update.error')
        format.html { render action: "edit" }
        format.json { render json: @bill.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    # @bill = Bill.find(params[:id])
    @bill.destroy
    flash[:success] = t('controllers.bill.flashs.destroy.success')
    respond_to do |format|
      format.html { redirect_to bills_url }
      format.json { head :no_content }
    end
  end

  private

  def require_creater
    @bill = Bill.find(params[:id])
    unless @bill.user == current_user
      flash[:error] = t('controllers.bill.require_creater')
      redirect_to :back
    end
  end
end
