# -*- coding: utf-8 -*-
FactoryGirl.define do
  factory :user do
    sequence(:name) { |n| "test_user#{n}" }  # sequence 方法会生成一系列不重复的 user
    sequence(:email) { |n| "test_user#{n}@gmail.com"}
    password  'test_user'
  end

  factory :good_name do
    #name "test_good_name#{_i}"
    sequence(:name) {|n| p n }
  end

  factory :good_information do
    good_name
    bill
    amount '11'
    price '22'
  end

  factory :bill do
    count       10
    payer_id    1
  end

end
