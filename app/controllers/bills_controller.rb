# -*- coding: utf-8 -*-
class BillsController < ApplicationController
  before_filter :require_creater, only: [:destroy, :update, :edit]
  after_filter :count_about_me, only: [:create, :update, :destroy]
  before_filter :handle_goods_infos , only: [:update, :create]

  include BillsHelper

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
    # 把已经有的账单信息发给前端
    @prePopulate = @bill.good_informations.map {|gf| {id: gf.good_name_id,
        name: gf.good_name, amount: gf.amount, price: gf.price, good_information_id: gf.id}}
    @good_information_ids = @bill.good_informations.map { |gf| gf.id } # 把最初的账单信息id传给前端
  end

  def create
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

  def my_bills
    @bills = current_user.bills
    @users = User.all
    render :index
  end

  def about_me
    @bills = current_user.bills + Bill.where('payer_id=? AND user_id <> ?', current_user.id, current_user.id)
    @users = User.all
    render :index
  end

  private

  def require_creater
    @bill = Bill.find(params[:id])
    unless creater? @bill
      flash[:error] = t('controllers.bill.require_creater')
      redirect_to bills_url
    end
  end

  def count_about_me
    about_me_bills = current_user.bills + Bill.where('payer_id=? AND user_id <> ?', current_user.id, current_user.id)
    cookies[:about_me_count] = about_me_bills.size
  end

  def handle_goods_infos

    good_name_ids = params[:good_name_ids].split(',') #获取账单中的name id
    _new_name_id = 50000 # 为防止冲突,故为新建账单创建一个比较大初始值

    if request.put? # 此时为更新
      @bill = Bill.find(params[:id])
      good_information_ids = params[:good_information_ids].split(' ') #获取最初的账单信息id值
      return_good_information_ids = [] #实际返回的账单信息id
    else
      @bill = current_user.bills.build(params[:bill])
    end


    good_name_ids.each do |id|
      unless id == '0' #当good name id 不为0时表示数据库中已存在对于的name
        if request.put?
          return_good_information_ids << params["good_information_id_#{id}"] #追加实际返回的账单信息id

          @bill.good_informations.find(params["good_information_id_#{id}"])
            .update_attributes(amount: params["amount_#{id}"], price: params["price_#{id}"])
        else
          @bill.good_informations.build(good_name_id: id,
                                  amount: params["amount_#{id}"], price: params["price_#{id}"])
        end
      else
        # 此时数据库中没得good name记录,则新建一条
        _new_name_id += 1
        GoodName.create!(name: params["new_name_#{_new_name_id}"])
        _last_good_name_id = GoodName.last.id
        @bill.good_informations.build(good_name_id: _last_good_name_id,
                                amount: params["new_amount_#{_new_name_id}"],
                                price: params["new_price_#{_new_name_id}"])
      end
    end
    # 删除的账单信息记录应该为最初的ids- 实际返回的ids
    if request.put?
      deleted_good_information_ids = good_information_ids - return_good_information_ids
      deleted_good_information_ids.each do |id|
        @bill.good_informations.find(id).destroy
      end
    end
  end
end
