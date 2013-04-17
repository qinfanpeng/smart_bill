FactoryGirl.define do
  factory :user do
    name      'qinfanpeng'
    password  'qinfanpeng'
  end

  factory :good_name do
    name 'test_good_name'
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
