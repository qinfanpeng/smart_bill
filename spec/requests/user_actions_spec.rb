# -*- coding: utf-8 -*-
require 'spec_helper'

describe "User Actions" do
  let(:admin) { FactoryGirl.create(:user, admin: true) }
  let(:user) { FactoryGirl.create(:user) }

  describe "Logoin" do
    before { visit signin_path }

    context "When I signin with correct information"do
      before { signin user }

      it "Then I should be taken to the index page" do
        page.should have_selector 'h1', text: '账单列表'
      end
      it "Then I should see a welcome notice" do
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
    context "When I forget my password" do
      context "When I click 'forget_password?'" do
        before { click_link '忘记密码?' }
        it "Then I should be taken to get_password page" do
          current_path.should eq forget_password_path
        end
      end
      context "When I input my correct email address" do
        before do
          click_link '忘记密码?'
          fill_in '邮箱地址', with: user.email
          click_button '找回密码'
        end
        it "Then I shoud see a notice 'your new password was sent to your emailbox'" do
          page.should have_selector('div.alert-success', test: '新密码将随后发送至您的邮箱, 请注意查收')
        end
        it "Then I shoud really sent out an email " do
          ActionMailer::Base.deliveries.empty?.should == false
        end
      end
    end
  end

  describe "Logout" do
    context "When I signout" do
      before { visit signout_path }

      it "Then I should see the success signouted notice" do
        page.should have_selector('div.alert-success', text: '您已经安全退出')
      end
    end
  end

  describe "As an admin user" do
    before { signin admin }

    context "When I add a new user" do
      before do
        visit new_user_path
        fill_in '用户名',  with: 'new_user'
        fill_in '密码',    with: 'new_user'
        fill_in '确认密码', with: 'new_user'
      end

      it "Then I should see a new user was added" do
        expect { click_button '添加' }.to change(User, :count).by(1)
      end
      it "And see a notice: 'a user was added successfull'" do
        click_button '添加'
        page.should have_selector('div.alert-success', text: '添加用户成功')
      end
    end

    context "When I delete a user" do
      before { visit user_path(user) }
      it "Then I should see the user reduce one" do
        expect { click_link '删除' }.to change(User, :count).by(-1)
      end
      it "And I should see a notice 'successfully deleted the user'"do
        click_link '删除'
        page.should have_selector('div.alert-success', text: '删除成功')
      end
    end
  end

  context "Aa a signined user" do
    before { signin user }

    context "edit email" do
      context "When I input with valid email address" do
        before do
          visit edit_email_user_path(user)
          fill_in "邮箱地址", with: '644458812@qq.com'
          click_button "edit_email_btn"
        end
        it "Then I should see the email address I updated" do
          page.should have_content('644458812@qq.com')
        end
        it "And I shoud see a notice: 'operation successfully'" do
          page.should have_selector('div.alert-success', text: '操作成功')
        end
      end

      context "When I input with invalid email address" do
        before do
          visit edit_email_user_path(user)
          fill_in "邮箱地址", with: 'invalid email'
          click_button "edit_email_btn"
        end
        it "Then I should see that I was still in the edit page" do
          current_path.should eq edit_email_user_path(user)
        end
        it "And I shoud see a notice: 'operation fail'" do
          page.should have_selector('div.alert-error', text: '操作失败')
        end
      end
    end

    context "edit password" do
      context "When I input with valid information" do
        before  do
          visit edit_password_user_path(user)
          fill_in "旧密码", with: user.password
          fill_in "密码", with: 'new_password'
          fill_in "确认密码", with: 'new_password'
          click_button "改密码"
        end
        it "Then I shoud see a notice: 'password update successfully'" do
          pending 'to remove the bug'
          #page.should have_selector('div.alert-error', text: '旧密码错误, 密码修改失败')
          page.should have_selector('div.alert-success', text: '密码修改成功')
        end
        it "And I should notice that my password was what I updated" do
          pending 'to remove the bug'
          user.password.should == 'new_password'
        end
      end

      context "When I input with invalid old password" do
        before do
          visit edit_password_user_path(user)
          fill_in "旧密码", with: 'not_the_old_password'
          fill_in "密码", with: 'new_password'
          fill_in "确认密码", with: 'new_password'
          click_button "改密码"
        end
        it "Then I should see that I was still in the edit page" do
          current_path.should eq edit_password_user_path(user)
        end
        it "And I shoud see a notice: 'old password error'" do
          page.should have_selector('div.alert-error', text: '旧密码错误, 密码修改失败')
        end
      end
    end
  end
end
