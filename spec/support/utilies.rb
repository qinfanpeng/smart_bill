# -*- coding: utf-8 -*-
def signin(user)
  visit signin_path
  fill_in '用户名',  with: user.name
  fill_in '密码',   with: user.password
  click_button '登录'

  # Sign in when not using Capybara as well., 比如在controller测试中直接调用post,get等方法时,必须使用下面代码
  cookies[:user_id] = user.id
end

def create_bill(args = {})
  user = args[:user] || User.create!(name: 'liuhui', password: 'liuhui', email: 'liuhui@mail.com')
  @bill = user.bills.build(payer_id: args[:payer_id]||1, count: args[:count]||1)
  @bill.good_informations.build(good_name_id: 1, amount: args[:amount]||1, price: args[:price]||1)
  @bill.save!
  @bill
end
