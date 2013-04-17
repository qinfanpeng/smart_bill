# -*- coding: utf-8 -*-
class GoodInformation < ActiveRecord::Base
  attr_accessible :amount, :price, :good_name_id
  belongs_to :bill

  belongs_to :good_name, foreign_key: :good_name_id, class_name: :GoodName
  belongs_to :bill, :inverse_of => :good_informations

  alias :old_good_name :good_name # 注意alias是关键字不是方法,故参数间无 ','
  def good_name
    unless old_good_name.nil?
      old_good_name.name
    else
      nil
    end
  end
end
