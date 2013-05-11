# -*- coding: utf-8 -*-
require 'spec_helper'

describe "Bill Actions" do
  before { @user = FactoryGirl.create(:user) }
  #let(:user) { FactoryGirl.create(:user) }
  let(:a_bill_of_the_user) { @user.bills.create!(count: 1, payer_id: @user.id)}

  subject { page }

  describe "As a signed user" do
    before { signin @user }

    describe "create bill" do
      before { visit new_bill_path }

      context "When I input valid information" do
        before do
          fill_in 'bill_goods_token_input',  with: 'test description'
          fill_in '小计',  with: 10
          select @user.name, from: '支付者'
        end

        it "Then I should create a bill" do
          expect { click_button '创建账单' }.to change(Bill, :count).by(1)
        end
        it "And the new bill's creater should be current user" do
          click_button '创建账单'
          Bill.last.user.name.should == @user.name
        end
        it "And the new bill's payer should be I selected user" do
          click_button '创建账单'
          Bill.last.payer.name.should == @user.name
        end
      end

      context "When I input invalid information" do
        before { fill_in 'bill_goods_token_input', with: 'test description' }

        it "Then I should not create a bill" do
          expect { click_button '创建账单' }.not_to change(Bill, :count).by(1)
        end
      end
    end

    describe "update bill" do
      before { visit edit_bill_path(a_bill_of_the_user) }
      context "When I update a bill with valid information" do
        before do
          fill_in '小计',  with: 11
          click_button '修改账单'
        end

        it "Then I should been taken to the show bill page" do
          page.should have_selector('h1', text: '账单')
        end
        it "And I should see 'updated description'" do
          page.should have_content '11'
        end
        it "And I should see a notice 'bill was successfully updated'" do
          page.should have_selector('div.alert-success', text: '账单修改成功')
        end
      end

      context "When I update a bill with invalid information" do
        before do
          fill_in '小计', with: ''
          click_button '修改账单'
        end

        it "Then I should see a error " do
          page.should have_selector('div.field_with_errors')
        end
      end
    end

    describe "delete bill" do
      before { visit bill_path(a_bill_of_the_user) }
      context "When I delete a bill" do
        it "Then I should deleted the bill" do
          expect { click_link '删除' }.to change(Bill, :count).by(-1)
        end

        it "And I should been take to the bills index page" do
          click_link '删除'
          current_path.should == bills_path
        end
      end
    end

    describe "list all bills" do
      context "When I go to the bill index page" do
        before { visit bills_path }
        it "Then I should see 'Bills'" do
          current_path.should == bills_path
        end
      end
    end

    describe "list my bills" do
      before do
        bill1 = @user.bills.create!(count: 1, payer_id: @user.id)
        bill2 = @user.bills.create!(count: 2, payer_id: @user.id)
      end
      context "When I click the link 'my bills'" do
        before { visit my_bills_path }
        it "Then I should see these bills's creater is me" do
          page.all('td.creater', text: @user.name).size.should == 2 # 注意学习此行代码的写法
        end
      end

      context "When I click about_me" do
        before { visit about_me_bills_path }
        it "Then I should see these bills's creater or payer must be me" do
          page.all('td', text: @user.name).size.should == 4 # 此处准备的测试数据中的creater和payer都是当前用户@user,故应是 4
        end
      end
    end

    context "settle bills" do
      before do
        @another = User.create!(name: 'another', password: 'another')
        bill1 = @user.bills.create!(count: 1, payer_id: @user.id)
        bill2 = @user.bills.create!(count: 2, payer_id: @user.id)
        bill3 = @user.bills.create!(count: 5 , payer_id: @another.id)
      end
      context "When I click settle_bill" do
        before { visit settle_bills_path }
        it "Then I shoud be taken to settle bill page" do
                  current_path.should == settle_bills_path
        end
        it "And I shoud see people's balance here" do
          @user.balance(Date.today).should == -1
          @another.balance(Date.today).should == 1
        end
        it "And I shoud see bill's total amount here" do
          Bill.total(Date.today).should == 8
        end
        it "And I shoud see bill's averge here" do
          Bill.averge(Date.today).should == 4
        end
      end
    end

  end
end
