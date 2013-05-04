require 'spec_helper'

describe User do
  before(:all) { @user =  FactoryGirl.create(:user) }

  subject { @user }

  it { should be_valid }
  it { should respond_to(:name) }
  it { should respond_to(:password) }
  it { should respond_to(:admin) }
  it { should respond_to(:email) }

end
