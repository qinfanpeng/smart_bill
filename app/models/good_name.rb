class GoodName < ActiveRecord::Base
  attr_accessible :name
  validates :name, presence: true, uniqueness: true

  has_many :good_informations, class_name: :GoodInformation, foreign_key: :good_name_id
end
