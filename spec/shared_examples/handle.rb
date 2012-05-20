require 'spec_helper'

shared_examples_for 'a handle' do
  describe "#close" do
    it "required a block" do
      expect { subject.close }.to raise_error(ArgumentError)
    end

    it "calls UV.close" do
      UV.should_receive(:close).once.with(pointer, subject.method(:on_close))
      subject.close {}
    end
  end

  describe "#active?" do
    it "is true for positive integers" do
      UV.should_receive(:is_active).with(pointer).and_return(2)
      subject.active?.should be_true
    end

    it "is false for integers less than 1" do
      UV.should_receive(:is_active).with(pointer).and_return(0)
      subject.active?.should be_false
    end
  end

  describe "#closing?" do
    it "is true for positive integers" do
      UV.should_receive(:is_closing).with(pointer).and_return(1)
      subject.closing?.should be_true
    end

    it "is false for integers less than 1" do
      UV.should_receive(:is_closing).with(pointer).and_return(-1)
      subject.closing?.should be_false
    end
  end
end