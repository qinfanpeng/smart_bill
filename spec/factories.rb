FactoryGirl.define do
  factory :bill do
    description 'test description'
    count       10
    payer_id    1
  end

  factory :user do
    name      'qinfanpeng'
    password  'qinfanpeng'
  end
end
