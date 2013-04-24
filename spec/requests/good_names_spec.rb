# -*- coding: utf-8 -*-
require 'spec_helper'

describe "GoodActions" do
  let(:admin) { FactoryGirl.create(:user, admin: true) }
  let(:good_name) { FactoryGirl.create(:good_name) }

  describe "As an admin" do
    before { signin admin }

    context "When I create a goods name" do
      before { visit new_good_name_path }

      context "with valid information" do
        before do
          fill_in "商品名", with: 'test_goods_name'
        end
        it "Then I should really add a new goods name" do
          expect { click_button '添加商品' }.to change(GoodName, :count).by(1)
        end
        it "And I should see a notice: 'a new goods name was added'" do
          click_button '添加商品'
          page.should have_selector('div.alert-success', text: '商品添加成功')
        end
      end

      context "with invalid information" do
        before do
          fill_in "商品名", with: ''
        end
        it "Then I should really add a new goods name" do
          expect { click_button '添加商品' }.to change(GoodName, :count).by(0)
        end
        it "And I should see a error 'goods name can't be blank'" do
          click_button '添加商品'
          page.should have_selector('div.alert-error', text: '商品名不能为空')
        end
      end
    end

    context "When I update a goods name" do
      before { visit edit_good_name_path(good_name) }

      context "with valid information" do
        before do
          fill_in "商品名", with: 'test_updated_goods_name'
          click_button '修改商品'
        end
        it "Then I should be taken to the show page" do
          current_path.should == good_name_path(good_name)
        end
        it "And I should see the updated content" do
          page.should have_content('test_updated_goods_name')
        end
        it "And I should see a notice: 'the new goods name was update'" do
          page.should have_selector('div.alert-success', text: '商品修改成功')
        end
      end

      context "with invalid information" do
        before do
          fill_in "商品名", with: ''
          click_button '修改商品'
        end
        it "Then I should see a error 'goods name can't be blank'" do
          page.should have_selector('div.alert-error', text: '商品名不能为空')
        end
      end
    end

    context "When I delete a goods name" do
      before { visit good_name_path(good_name) }

      it "Then I should really delete the goods name" do
        expect{ click_link '删除'}.to change(GoodName, :count).by(-1)
      end
      it "And I should see a notice: 'a goods name was successfull deleted'" do
        click_link '删除'
        page.should have_selector('div.alert-success', text: '删除成功')
      end
    end
  end
end
