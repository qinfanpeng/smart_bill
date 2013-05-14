class JoinedGroupMember < ActiveRecord::Base
  belongs_to :joined_group
  belongs_to :member, class_name: :User
end
