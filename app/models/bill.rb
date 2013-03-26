class Bill < ActiveRecord::Base
  attr_accessible :count, :description

  validates :count, presence: true
  validates :description, presence: true

end
