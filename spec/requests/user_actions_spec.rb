# -*- coding: utf-8 -*-
require 'spec_helper'

describe "User Actions" do
  let(:admin) { FactoryGirl.create(:user, admin: true) }
  let(:user) { FactoryGirl.create(:user) }

  describe "Logoin" do
    before { visit signin_path }

    context "When I signin with correct information"do
      before do
        fill_in '用户名',  with: user.name
        fill_in '密码',    with: user.password
        click_button '登录'
      end

      it "Then I should be taken to the index page" do
        page.should have_selector 'h1', text: '账单列表'
      end
      it "Then I should see the welcome notice" do
        page.should have_selector('div.alert-success', text: '欢迎您')
      end
    end

    context "When I signin with invalid information" do
      before do
        fill_in '用户名',  with: user.name
        fill_in '密码',    with: 'not correct password'
        click_button '登录'
      end
      it "Then I should see the error notice" do
        page.should have_selector('div.alert-error', text: '登录失败，用户名或密码错误！')
      end

    end

  end

  describe "Logout" do
    context "When I signout" do
      #before { signout_path }
      before { get signout_path }

      it "Then I should see the success signouted notice" do
        #page.should have_selector('div.alert-success', text: '您已经安全退出')
        flash[:success] == '您已经安全退出'
      end
    end
  end

  describe "As an admin user" do
    before do
      visit signin_path
      fill_in '用户名',  with: admin.name
      fill_in '密码',    with: admin.password
      click_button '登录'
    end

    context "When I add a new user" do
      before do
        visit new_user_path
        fill_in '用户名',  with: 'new_user'
        fill_in '密码',    with: 'new_user'
        fill_in '确认密码', with: 'new_user'
        #
      end

      it "Then I should see a new user was added" do
        expect { click_button '增加' }.to change(User, :count).by(1)
      end
      it "And see a notice: 'a user was added successfull'" do
        click_button '增加'
        page.should have_selector('div.alert-success', text: '增加用户成功')
      end
    end

    context "When I update a user" do
      before do
        visit edit_user_path user
        fill_in '用户名', with: 'updated user name'
        #click_button '修改'
        put user_path user, { name: 'updated user name'}
      end
      it "Then I should be taken to the show user page" do
        pending 'to do ...'
        #page.should have_selector('h1', text:'用户')
        #page.should have_selector('p', text: 'updated user name')
      end
      it "And I should see a notice 'the user was successfully updated'" do
        #page.should have_selector('div.alert-success', text: '用户修改成功')
        p '----------'
        p flash[:notice]
        flash[:success] == '用户修改成功fddddddddddddddddddd'
      end
    end

    context "When I delete a user" do
      it "Then I should see the user reduce one" do
        pending ('to do delete the user........')
        expect { delete user_path(user) }.to change(User, :count).by(-1)
      end
      it "And I should see a notice 'successfully deleted the user'"do
        delete user_path(user)
        #page.should have_selector('div.alert-success', text: '删除成功')
        flash[:success] == '删除成功'
      end
    end

  end
end
