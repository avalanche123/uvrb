require 'spec_helper'

shared_examples_for 'a handle' do
  describe "#ref" do
    it "calls UV.ref" do
      UV.should_receive(:ref).with(pointer)

      subject.ref
    end
  end

  describe "#unref" do
    it "calls UV.unref" do
      UV.should_receive(:unref).with(pointer)

      subject.unref
    end
  end

  describe "#close" do
    it "calls UV.close" do
      UV.should_receive(:close).once.with(pointer, subject.method(:on_close))
      subject.close
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