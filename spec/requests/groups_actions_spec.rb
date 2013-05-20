# -*- coding: utf-8 -*-
require 'spec_helper'

describe "Group Actions" do
  before { @user = FactoryGirl.create(:user) }
  let(:group) { @user.created_groups.create!(name: 'test_group1') }
  let(:another) { FactoryGirl.create(:user, name: 'another') }
  describe "As a signed user" do
    before { signin @user }
    describe "create group" do
      describe "When I input valid information" do
        before do
          visit new_group_path
          fill_in '账单组名', with: 'test_group'
        end
        it "Then I should really create a group" do
          expect { click_button '新建账单组' }.to change(Group, :count).by(1)
        end
        it "And I should be taken to add member page" do
          click_button '新建账单组'
          current_path.should == new_member_to_group_path(Group.last)
        end
        it "And I shoud see a notice 'a group was successfully created, please add member for it'" do
          click_button '新建账单组'
          page.should have_selector('div.alert-success', text: '账单组创建成功, 请为它添加成员')
        end
      end

      describe "When I input invalid information" do
        before do
          visit new_group_path
          click_button '新建账单组'
        end
        it "Then I should still in the new page" do
          current_path.should == new_group_path
        end
        it "And I should see a notice 'fail to creat group'" do
          page.should have_selector('div.alert-error', text: '账单组创建失败')
        end
      end
    end

    describe "Add member to a group" do
      before { visit new_member_to_group_path(group) }
      describe "When I enter another's name in the search form" do
        before do
          fill_in 'user_name', with: another.name
          click_button '查询'
        end
        it "Then I have the another user is here" do
          page.all('td', text: another.name).size.should == 1
        end
        describe "When I add another to the group" do
          before { click_link '添加' }
          it "Then I shoud be taken to the members of the group page" do
            current_path.should == members_of_group_path(group)
          end
        end
      end
    end

    describe "Remove member of a group" do
      before { post add_member_to_group_path(group, member_id: another.id)}

      context "When I remove a member of the group" do
        before { visit members_of_group_path(group) }

        it "Then I should really removed the member" do
          expect { click_link '删除' }.to change(group.members, :count).by(-1)
        end
        it "And I should see a notice 'a member was successfully removed'" do
          click_link '删除'
          page.should have_selector('div.alert-success', text: '删除成员成功')
        end
      end
    end

    describe "Show a group" do
      before { post add_member_to_group_path(group, member_id: another.id)}
      context "When I go to the group show page" do
        before { visit group_path(group) }
        it "Then I should see the group's name, creater, and it's member" do
          page.should have_content group.name
          page.should have_content group.creater.name
          page.should have_content another.name
        end
      end
    end

    describe "List my groups " do
      before do
        @group1 = @user.created_groups.create!(name: 'group1')
        @group2 = another.created_groups.create!(name: 'group2')
        post add_member_to_group_path(@group2, member_id: @user.id)
      end
      describe "When I go to my groups page" do
        before { visit my_groups_path }

        it "Then I should see all my groups(joined and created)" do
          pending 'to remove the bug ...'
          p @user.joined_groups
          #page.all(:td, text: 'group1').size.should == 1
          page.all(:td, text: 'group2').size.should == 1
        end
      end
    end

    describe "Delete group" do
      before { @group1 = @user.created_groups.create!(name: 'group1') }
      describe "When I delete a group" do
        before { visit group_path(@group1) }

        it "Then I should really delete the group" do
          expect { click_link '删除' }.to change(Group, :count).by(-1)
        end
        it "And I should see a notice 'a group was successfuly deleted'" do
          click_link '删除'
          page.should have_selector('div.alert-success', text: '账单组删除成功')
        end
      end
    end
  end


end
