# -*- coding: utf-8 -*-
class GroupsController < ApplicationController
  before_filter :prepare_page_data, only: [:index, :new_member, :my, :members_of]
  before_filter :require_creater, only: [:destroy, :remove_member_of, :new_member_to, :add_member_to]
  before_filter :not_creater, only: [:add_member_to, :remove_member_of]
  before_filter :prepare_date_data, only: [:bills_of, :settle]
  before_filter :prepare_page_data, only: [:bills_of, :settle]
  respond_to :html, :json

  def new
    @group = Group.new
  end

  def create
    @group = current_user.created_groups.build(params[:group])
    if @group.save and JoinedGroupMember.new(joined_group_id: @group.id, member_id: current_user.id).save
      flash[:success] = t('group.create_success')
      redirect_to new_member_to_group_path(@group)
    else
      flash[:error] = t('group.create_error')
      redirect_to new_group_url
    end
  end

  def new_member_to
    group_member_ids = '('
    @group.members.each do |m|
      group_member_ids << m.id.to_s + ','
    end
    group_member_ids.chop! << ')'

    @group = Group.find(params[:id])
    if params[:user_name]
      @users = User.where('name like ?', "%#{params[:user_name]}%")
        .where("id not in #{group_member_ids}")
        .paginate(page: params[:page], per_page: 10)
    end
  end

  def add_member_to
    joined_group_member = JoinedGroupMember.new(joined_group_id: @group.id, member_id: @member.id)
    if joined_group_member.save
      flash[:success] = t('group.add_member_success')
      redirect_to members_of_group_path(@group)
    else
      flash[:error] = t('group.add_member_error')
      render :new_member
    end
  end

  def members_of
    @group = Group.find(params[:id])
    @members = @group.members.paginate(page: params[:page], per_page: 10)
  end

  def remove_member_of
    joined_group_member = JoinedGroupMember.find_by_joined_group_id_and_member_id(@group.id, params[:member_id])
    joined_group_member.destroy
    flash[:success] = t('group.remove_member_success')
    redirect_to members_of_group_path(@group)
  end

  def my
    @groups = current_user.joined_groups.paginate(page: params[:page], per_page: 10)
  end

  def destroy
    @group.destroy
    flash[:success] = t('group.remove_success')
    redirect_to my_groups_path
  end

  def show
    @group = Group.find(params[:id])
    @members = @group.members.paginate(page: params[:page], per_page: 7)
  end

  def members_select_of
    @group = Group.find(params[:id])
    @members = @group.members
    render json: @members, only: [:id, :name]
  end

  def bills_of
    @group = Group.find(params[:id])
    @bills = @group.bills
      .where('created_at > ? AND created_at < ?',
         @date.beginning_of_month.beginning_of_day,
         @date.end_of_month.end_of_day)
      .paginate(page: params[:page], per_page: 10)
  end

  def settle # 结算
    @group = Group.find(params[:id])
    @users = @group.members
      .paginate(page: params[:page], per_page: 10)
  end


  private
  def not_creater
    @group = Group.find(params[:id])
    @member = User.find(params[:member_id])
    if @group.creater == @member
      flash[:error] = t('group.not_creater_error')
      redirect_to members_of_group_path(@group)
    end
  end

  def require_creater
    @group = Group.find(params[:id])
    unless @group.creater == current_user
      flash[:error] = t('group.require_creater_error')
      redirect_to my_groups_path
    end
  end
end
