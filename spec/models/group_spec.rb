require 'spec_helper'

describe Group do
  before(:all) do
    @user =  FactoryGirl.create(:user)
    @group = @user.created_groups.create!(name: 'test_group')
  end
  subject { @group }

  it { should be_valid }
  it { should respond_to(:name) }
  it { should respond_to(:creater) }
  it { should respond_to(:members) }

end
