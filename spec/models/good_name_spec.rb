require 'spec_helper'

describe GoodName do
  before(:all) { @good_name = FactoryGirl.create(:good_name) }
  subject { @good_name }

  it { should be_valid }
  it { should respond_to(:name) }
end
