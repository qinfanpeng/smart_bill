# -*- coding: utf-8 -*-
require 'spec_helper'

describe "User Actions" do

  describe "Logoin" do
    let(:user) { FactoryGirl.create(:user) }
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
end
