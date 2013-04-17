require 'spec_helper'

describe Bill do
  before(:all) { @bill = create_bill }
 # before { @bill = FactoryGirl.create(:bill) }
  subject { @bill }

  it { should be_valid }
  it { should respond_to(:good_informations) }
  it { should respond_to(:count) }
  it { should respond_to(:payer_id) }


  describe "attributes validate: " do
    context "when goods is not present" do
      before { @bill.good_informations.delete_all }
      #it { should_not be_valid }
      pending 'to remvoe the bug'
    end
    context "when count is not present" do
      before { @bill.count = '' }
      it { should_not be_valid }
    end
    context "When payer is not present" do
      before { @bill.payer_id = nil }
      it { should_not be_valid }
    end
  end

end
