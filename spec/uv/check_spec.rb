require 'spec_helper'

describe UV::Check do
  let(:handle_name) { :check }
  let(:loop) { double() }
  let(:pointer) { double() }
  subject { UV::Check.new(loop, pointer) }

  it_behaves_like 'a handle'

  describe "#start" do
    it "requires a block" do
      expect { subject.start }.to raise_error(ArgumentError)
    end

    it "calls UV.check_start" do
      UV.should_receive(:check_start).with(pointer, subject.method(:on_check))

      subject.start { |e| }
    end
  end

  describe "#stop" do
    it "calls UV.check_stop" do
      UV.should_receive(:check_stop).with(pointer)

      subject.stop
    end
  end
end