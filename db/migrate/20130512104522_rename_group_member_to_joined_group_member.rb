class RenameGroupMemberToJoinedGroupMember < ActiveRecord::Migration
  def change
    rename_table :group_members, :joined_group_members
  end
end
