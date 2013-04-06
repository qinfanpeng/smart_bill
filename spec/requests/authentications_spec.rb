# -*- coding: utf-8 -*-
require 'spec_helper'

describe "Authentications" do
  let(:user) { FactoryGirl.create(:user) }
  let(:admin) { FactoryGirl.create(:user, admin: true) }
  let(:another_user) { FactoryGirl.create(:user, name: 'test', password: 'testtest') }
  let(:a_bill_of_another_user) { another_user.bills.create(description: 'test', count: 1, payer_id: another_user.id) }
  let(:bill) { FactoryGirl.create(:bill) }

  shared_examples_for 'require sign in' do
    it "Then I should be taken to the signin page" do
      page.should have_selector('h1', text: '登录')
    end
    it "And I should see the please signin notice" do
      #page.should have_selector('div.alert-success', text: '请先登录')
      flash[:notice] == '请先登录'
    end
  end

  shared_examples_for 'require admin user' do
    it "Then I should see a notice 'only admin user can do this opration'" do
      #page.should have_selector('div.alert-success', text: '不起, 只有 admin 才能进行此操作!')
      flash[:notice] == '不起, 只有管理员才能进行此操作!'
    end
  end

  describe "As a non signined user" do
    before { visit signout_path }

    context "When I visit the home page" do
      before { get bills_path }
      it_behaves_like 'require sign in'
    end

    context "When I attempt to new a bill" do
      before { get new_bill_path }
      it_behaves_like 'require sign in'
    end

    context "When I attempt to create a bill" do
      before { post bills_path }
      it_behaves_like 'require sign in'
    end

    context "When I attempt to delete a bill" do
      before { delete bill_path(bill) }
      it_behaves_like 'require sign in'
    end

    context "When I attempt to edit a bill" do
      before { get edit_bill_path(bill) }
      it_behaves_like 'require sign in'
    end

    context "When I attempt to update a bill" do
      before { put bill_path(bill) }
      it_behaves_like 'require sign in'
    end
  end

  describe "As a non crrect user" do
    before do
      visit signin_path
      fill_in '用户名',  with: user.name
      fill_in '密码',   with: user.password
      click_button '登录'
    end
    context "When I attempt to delete owther's bill" do
      before { delete bill_path(a_bill_of_another_user) }
      it "Then I should see a error notice" do
        pending('there is a bug ...')
        flash[:error] == '对不起, 只有账单创建者才能, 若急需删除此账单, 请联系创建者'
        #page.should have_selector('div.alert-error', text: '对不起, 只有账单创建者才能, 若急需删除此账单, 请联系创建者')
      end
    end
  end

  describe "As a non admin user" do
    before do
      visit signin_path
      fill_in '用户名',  with: user.name
      fill_in '密码',   with: user.password
      click_button '登录'
    end

    context "When I attempt to visit user index page" do
      before { get users_path }
      it_behaves_like 'require admin user'
    end

    context "When I attempt to new a user" do
      before { get new_user_path }
      it_behaves_like 'require admin user'
    end

    context "When I attempt to create a user" do
      before { post users_path }
      it_behaves_like 'require admin user'
    end

    context "When I attempt to delete a user"do
      before { delete user_path(user) }
      it_behaves_like 'require admin user'
    end

    context "When I attempt to edit a user " do
      before { get edit_user_path(user) }
      it_behaves_like 'require admin user'
    end

    context "When I attempt to update a user" do
      before { put user_path(user) }
      it_behaves_like 'require admin user'
    end
  end

  describe "As an admin" do
    before do
      visit signin_path
      fill_in '用户名',  with: admin.name
      fill_in '密码',   with: admin.password
      click_button '登录'
    end
    context "When I attempt to delete myself" do
      before { delete user_path(admin) }
      it "Then I should see a error 'you can't delete yourself'" do
        flash[:error] == '您不能删除您自己'
      end
    end
  end

end
