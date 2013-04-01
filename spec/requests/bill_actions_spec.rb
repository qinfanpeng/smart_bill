# -*- coding: utf-8 -*-
require 'spec_helper'

describe "Bill Actions" do
  before do
    @bill = FactoryGirl.create(:bill)
    @user = FactoryGirl.create(:user)
  end
  let(:a_bill_of_the_user) { @user.bills.create(description: 'test', count: 1, payer_id: @user.id)}
  subject { page }

  describe "As a signed user" do
    before do
      visit signin_path
      fill_in '用户名',  with: @user.name
      fill_in '密码',   with: @user.password
      click_button '登录'
    end

    describe "create bill" do
      before { visit new_bill_path }

      context "When I input valid information" do
        before do
          fill_in '明细',  with: 'test description'
          fill_in '金额',  with: 10
          select @user.name, from: '支付者'
        end
        it "Then I should create a bill" do
          expect { click_button '创建账单' }.to change(Bill, :count).by(1)
        end
        it "And the new bill's creater should be current user" do
          click_button '创建账单'
          Bill.last.user.name == @user.name
        end
        it "And the new bill's payer should be I selected user" do
          click_button '创建账单'
          Bill.last.payer.name == @user.name
        end
      end

      context "When I input invalid information" do
        before { fill_in '明细', with: 'test description' }

        it "Then I should not create a bill" do
          expect { click_button '创建账单' }.not_to change(Bill, :count).by(1)
        end
      end
    end

    describe "update bill" do
      before { visit edit_bill_path(a_bill_of_the_user) }

      context "When I update a bill with valid information" do
        before do
          fill_in '明细', with: 'updated description'
          click_button '修改账单'
          #put bill_path(@bill)
        end

        it "Then I should been taken to the show bill page" do
          #response.should redirect_to @bill
          page.should have_selector('h1', text: '账单')
        end
        it "And I should see 'updated description'" do
          page.should have_content 'updated description'
        end
        it "And I should see a notice 'bill was successfully updated'" do
          page.should have_selector('div.alert-success', text: '账单修改成功')
          #flash[:success].should == '账单修改成功'

        end
      end

      context "When I update a bill with invalid information" do
        before do
          fill_in '明细', with: ''
          click_button '修改账单'
        end

        it "Then I should see a error " do
          page.should have_selector('div.field_with_errors textarea#bill_description')
        end
      end
    end

    describe "delete bill" do

      context "When I delete a bill" do
        it "Then I should deleted the bill" do
          #expect { delete bill_path(@bill) }.to change(Bill, :count).by(-1)
          delete bill_path(a_bill_of_the_user)
          flash[:success] == '删除账单成功'
        end

        it "And I should been take to the bills index page" do
          delete bill_path(a_bill_of_the_user)
          #response.should redirect_to(bills_url)
          page.should have_selector('h1', text: '账单列表')
        end
      end
    end

    describe "list all bills" do
      context "When I go to the bill index page" do
        before { visit bills_path }

        it "Then I should see 'Bills'" do
          page.should have_selector('h1', text: '账单列表')
        end
      end
    end

  end
end
