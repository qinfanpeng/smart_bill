class RenameGroupIdToJoinedGroupIdOfJoinedGroupMemberTable < ActiveRecord::Migration
  def change
    rename_column :joined_group_members, :group_id, :joined_group_id
  end
end
