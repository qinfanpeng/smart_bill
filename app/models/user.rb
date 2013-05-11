# -*- coding: utf-8 -*-
class User < ActiveRecord::Base
  attr_accessible :name, :password, :password_confirmation, :admin, :email

  validates :name, presence: true
  validates :password, presence: true, length: {minimum: 6}
  validates :email, :format => { :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/}, allow_nil: true
  validates_confirmation_of :password

  has_many :bills, dependent: :destroy
  has_many :paid_bills, dependent: :destroy, class_name: 'Bill', foreign_key: 'payer_id'

  has_secure_password

  def paid(date)
    self.paid_bills
      .where('created_at > ? AND created_at < ?',
       date.beginning_of_month.beginning_of_day,
       date.end_of_month.end_of_day)
      .inject(0) {|paid, paid_bill| paid + paid_bill.count }
  end

  def balance(date)
    self.paid(date) - Bill.averge(date)
  end
end
