class User < ActiveRecord::Base
  attr_accessible :name, :password
  has_many :bills, dependent: :destroy
  has_many :paid_bills, dependent: :destroy, class_name: 'Bill', foreign_key: 'payer_id'

  def self.authenticate(user)
    _user = find_by_name(user[:name])
    if _user && _user.password == user[:password]
      _user
    else
      nil
    end
  end

  def paid
    self.paid_bills.inject(0) {|paid, paid_bill| paid + paid_bill.count }
  end

  def figure
    self.paid - Bill.averge
  end

end
