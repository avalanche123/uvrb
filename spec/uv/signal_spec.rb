require 'spec_helper'

describe UV::Signal do
  let(:handle_name) { :signal }
  let(:loop) { double() }
  let(:pointer) { double() }
  subject { UV::Signal.new(loop, pointer) }

  it_behaves_like 'a handle'

  describe "#start" do
    let(:signo) { 2 }

    it "requires a block" do
      expect { subject.start(signo) }.to raise_error(ArgumentError)
    end

    it "calls UV.signal_start" do
      UV.should_receive(:signal_start).with(pointer, subject.method(:on_signal), signo)

      subject.start(signo) { |e| }
    end
  end

  describe "#stop" do
    it "calls UV.signal_stop" do
      UV.should_receive(:signal_stop).with(pointer)

      subject.stop
    end
  end
end