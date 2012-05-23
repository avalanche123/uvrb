require 'spec_helper'

describe UV::IPC do
  let(:handle_name) { :ipc }
  let(:loop) { double() }
  let(:pointer) { double() }
  subject { UV::IPC.new(loop, pointer) }

  it_behaves_like 'a handle'
  it_behaves_like 'a stream'

  describe "#bind" do
    let(:name) { "/tmp/filename.ipc" }

    it "calls UV.pipe_bind" do
      UV.should_receive(:pipe_bind).with(pointer, name)

      subject.bind(name)
    end
  end

  describe "#connect" do
    let(:name) { "/tmp/filename.ipc" }
    let(:connect_request) { double() }

    it "requires a block" do
      expect{ subject.connect(name) }.to raise_error(ArgumentError)
    end

    it "calls UV.pipe_connect" do
      UV.should_receive(:create_request).with(:uv_connect).and_return(connect_request)
      UV.should_receive(:pipe_connect).with(connect_request, pointer, name, subject.method(:on_connect))

      subject.connect(name) { |e| }
    end
  end

  describe "#pending_instances=" do
    it "calls UV.pipe_pending_instances" do
      UV.should_receive(:pipe_pending_instances).with(pointer, 5)
      subject.pending_instances = 5
    end
  end
end