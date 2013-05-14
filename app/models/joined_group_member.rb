class JoinedGroupMember < ActiveRecord::Base
  attr_accessible :joined_group_id, :member_id
  belongs_to :joined_group
  belongs_to :member, class_name: :User
end
