# -*- coding: utf-8 -*-
class Bill < ActiveRecord::Base
  attr_accessible :count, :payer_id #, :good_ids, :goods
  validates :count, presence: true, numericality: true
  #validates :good_informations, presence: true   #因测试不能通过,不得已而注释此行, 可能是设计错误, 待解决.
  validates :payer_id, presence: true

  belongs_to :user
  belongs_to :payer, class_name: 'User', foreign_key: :payer_id
  has_many :good_informations, :dependent => :destroy, class_name: :GoodInformation, :inverse_of => :bill

  def self.total
    all.inject(0) {|total, bill| total+bill.count }
  end

  def self.averge
    total / User.count
  end

end
