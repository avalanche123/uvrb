require 'spec_helper'

describe UV::Prepare do
  let(:handle_name) { :prepare }
  let(:loop) { double() }
  let(:pointer) { double() }
  subject { UV::Prepare.new(loop, pointer) }

  it_behaves_like 'a handle'

  describe "#start" do
    it "requires a block" do
      expect { subject.start }.to raise_error(ArgumentError)
    end

    it "calls UV.prepare_start" do
      UV.should_receive(:prepare_start).with(pointer, subject.method(:on_prepare))

      subject.start { |e| }
    end
  end

  describe "#stop" do
    it "calls UV.prepare_stop" do
      UV.should_receive(:prepare_stop).with(pointer)

      subject.stop
    end
  end
end