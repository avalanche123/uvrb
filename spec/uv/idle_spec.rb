require 'spec_helper'

describe UV::Idle do
  let(:handle_name) { :idle }
  let(:loop) { double() }
  let(:pointer) { double() }
  subject { UV::Idle.new(loop, pointer) }

  it_behaves_like 'a handle'

  describe "#start" do
    it "requires a block" do
      expect { subject.start }.to raise_error(ArgumentError)
    end

    it "calls UV.idle_start" do
      UV.should_receive(:idle_start).with(pointer, subject.method(:on_idle))

      subject.start { |e| }
    end
  end

  describe "#stop" do
    it "calls UV.idle_stop" do
      UV.should_receive(:idle_stop).with(pointer)

      subject.stop
    end
  end
end