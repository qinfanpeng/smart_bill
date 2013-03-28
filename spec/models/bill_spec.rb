require 'spec_helper'

describe Bill do
  let(:bill) { Bill.new(description: 'this is a test bill description', count: 10) }
  subject { bill }

  it { should be_valid }
  it { should respond_to(:description) }
  it { should respond_to(:count) }


  describe "attributes validate: " do
    context "when description is not present" do
      before { bill.description = '' }
      it { should_not be_valid }
    end
    context "when count is not present" do
      before { bill.count = '' }
      it { should_not be_valid }
    end

  end

end
