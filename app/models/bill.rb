# -*- coding: utf-8 -*-
class Bill < ActiveRecord::Base
  attr_accessible :count, :description, :payer_id
  validates :count, presence: true, numericality: true
  validates :description, presence: true
  validates :payer_id, presence: true

  belongs_to :user
  belongs_to :payer, class_name: 'User', foreign_key: :payer_id

  def self.total
    all.inject(0) {|total, bill| total+bill.count }
  end

  def self.averge
    total / User.count
  end

end
