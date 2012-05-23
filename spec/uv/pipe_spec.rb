require 'spec_helper'

describe UV::Pipe do
  let(:handle_name) { :pipe }
  let(:loop) { double() }
  let(:pointer) { double() }
  subject { UV::Pipe.new(loop, pointer) }

  it_behaves_like 'a handle'
  it_behaves_like 'a stream'

  describe "#open" do
    let(:fileno) { 6555 }

    it "calls UV.pipe_open" do
      UV.should_receive(:pipe_open).with(pointer, fileno)

      subject.open(fileno)
    end
  end

  describe "#pending_instances=" do
    it "calls UV.pipe_pending_instances" do
      UV.should_receive(:pipe_pending_instances).with(pointer, 5)
      subject.pending_instances = 5
    end
  end
end