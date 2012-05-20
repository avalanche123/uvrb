require 'spec_helper'

describe UV::TCP do
  let(:handle_name) { :tcp }
  let(:loop) { double() }
  let(:pointer) { double() }
  subject { UV::TCP.new(loop, pointer) }

  it_behaves_like 'a handle'
  it_behaves_like 'a stream'

  describe "#bind" do
  end

  describe "#connect" do
  end

  describe "#sockname" do
  end

  describe "#peername" do
  end

  describe "#enable_nodelay" do
    it "calls UV.tcp_nodelay" do
      UV.should_receive(:tcp_nodelay).with(pointer, 1)

      subject.enable_nodelay
    end
  end

  describe "#disable_nodelay" do
    it "calls UV.tcp_nodelay" do
      UV.should_receive(:tcp_nodelay).with(pointer, 0)

      subject.disable_nodelay
    end
  end

  describe "#enable_keepalive" do
    let(:keepalive_delay) { 150 }

    it "calls UV.tcp_keepalive" do
      UV.should_receive(:tcp_keepalive).with(pointer, 1, keepalive_delay)

      subject.enable_keepalive(keepalive_delay)
    end
  end

  describe "#disable_keepalive" do
    it "calls UV.tcp_keepalive" do
      UV.should_receive(:tcp_keepalive).with(pointer, 0, 0)

      subject.disable_keepalive
    end
  end

  describe "#enable_simultaneous_accepts" do
    it "calls UV.tcp_simultaneous_accepts" do
      UV.should_receive(:tcp_simultaneous_accepts).with(pointer, 1)

      subject.enable_simultaneous_accepts
    end
  end

  describe "#disable_simultaneous_accepts" do
    it "calls UV.tcp_simultaneous_accepts" do
      UV.should_receive(:tcp_simultaneous_accepts).with(pointer, 0)

      subject.disable_simultaneous_accepts
    end
  end
end