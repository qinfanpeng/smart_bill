class Group < ActiveRecord::Base
  attr_accessible :name

  validates :name, presence: true
  has_many :joined_group_members, foreign_key: :joined_group_id
  has_many :members, :through => :joined_group_members, class_name: :User
  has_many :bills

  belongs_to :creater, class_name: :User
end
