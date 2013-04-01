module BillsHelper
  def total
    Bill.total
  end

  def averge
    Bill.averge
  end

  def creater? bill
    bill.user == current_user
  end
end
