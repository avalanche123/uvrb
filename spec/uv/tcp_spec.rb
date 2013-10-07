require 'spec_helper'

describe UV::TCP do
  let(:handle_name) { :tcp }
  let(:loop) { double() }
  let(:pointer) { double() }
  subject { UV::TCP.new(loop, pointer) }

  it_behaves_like 'a handle'
  it_behaves_like 'a stream'

  describe "#open" do
    let(:fd) { 4 }

    it "calls UV.tcp_open" do
      UV.should_receive(:tcp_open).with(pointer, fd)

      subject.open(fd)
    end
  end

  describe "#bind" do
    let(:ip_addr) { double() }
    let(:port) { 0 }

    context "ipv4" do
      let(:ip) { "0.0.0.0" }

      it "calls UV.tcp_bind" do
        UV.should_receive(:ip4_addr).with(ip, port).and_return(ip_addr)
        UV.should_receive(:tcp_bind).with(pointer, ip_addr)

        subject.bind(ip, port)
      end
    end

    context "ipv6" do
      let(:ip) { "::" }

      it "calls UV.tcp_bind6" do
        UV.should_receive(:ip6_addr).with(ip, port).and_return(ip_addr)
        UV.should_receive(:tcp_bind6).with(pointer, ip_addr)

        subject.bind(ip, port)
      end
    end
  end

  describe "#connect" do
    let(:connect_request) { double() }
    let(:ip_addr) { double() }
    let(:port) { 0 }

    it "requires a block" do
      expect { subject.connect("0.0.0.0", port) }.to raise_error(ArgumentError)
    end

    context "ipv4" do
      let(:ip) { "0.0.0.0" }

      it "calls UV.tcp_connect" do
        UV.should_receive(:create_request).with(:uv_connect).and_return(connect_request)
        UV.should_receive(:ip4_addr).with(ip, port).and_return(ip_addr)
        UV.should_receive(:tcp_connect).with(connect_request, pointer, ip_addr, subject.method(:on_connect))

        subject.connect(ip, port) { |e| }
      end
    end

    context "ipv6" do
      let(:ip) { "::" }

      it "calls UV.tcp_connect6" do
        UV.should_receive(:create_request).with(:uv_connect).and_return(connect_request)
        UV.should_receive(:ip6_addr).with(ip, port).and_return(ip_addr)
        UV.should_receive(:tcp_connect6).with(connect_request, pointer, ip_addr, subject.method(:on_connect))

        subject.connect(ip, port) { |e| }
      end
    end
  end

  # describe "#sockname" do
  #   let(:sockaddr) { double() }
  #   let(:len) { 15 }
  # 
  #   it "calls UV.tcp_getsockname" do
  #     UV.should_receive(:tcp_getsockname).with(pointer, sockaddr, len)
  #   end
  # end
  # 
  # describe "#peername" do
  # end

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