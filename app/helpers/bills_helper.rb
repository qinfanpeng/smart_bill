module BillsHelper
  def total
    Bill.total
  end

  def averge
    Bill.averge
  end

  def creater? bill
    bill.user.id == current_user.id
  end

  def about_me_count
    cookies[:about_me_count]
  end

  def goods_names bill
    bill.good_informations.map{|gf| gf.good_name}.join ','
  end

  def handle_members_of_group(group_id)
    if group_id == 0
      [current_user]
    else
      Group.find(group_id).members
    end
  end
end
