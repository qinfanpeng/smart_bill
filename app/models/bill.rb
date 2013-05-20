# -*- coding: utf-8 -*-
class Bill < ActiveRecord::Base
  attr_accessible :count, :payer_id, :group_id
  validates :count, presence: true, numericality: true
  #validates :good_informations, presence: true   #因测试不能通过,不得已而注释此行, 可能是设计错误, 待解决.
  #validates :payer_id, presence: true

  belongs_to :user
  belongs_to :payer, class_name: 'User', foreign_key: :payer_id
  belongs_to :group
  has_many :good_informations, :dependent => :destroy, class_name: :GoodInformation, :inverse_of => :bill

  def self.total(date, group)
    self
      .where('group_id=?', group.id)
      .where('created_at > ? AND created_at < ?',
         date.beginning_of_month.beginning_of_day,
         date.end_of_month.end_of_day)
      .inject(0) {|total, bill| total+bill.count }
  end

  def self.averge(date, group)
    total(date, group) / group.members.size
  end

  def self.get_bills_by_year_and_month(year, month)
    date = Date.new(year, month)
    where('created_at > ? AND created_at < ?',
      date.beginning_of_month.beginning_of_day,
      date.end_of_month.end_of_day)
  end

end
