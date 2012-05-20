require 'ipaddr'

module UV
  class TCP
    include Stream, Handle, Resource, Listener, Net

    def bind(ip, port)
      @socket = create_socket(IPAddr.new(String(ip)), Integer(port))
      @socket.bind
    end

    def connect(ip, port, &block)
      raise ArgumentError, "no block given", caller unless block_given?
      @connect_block = block
      @socket = create_socket(IPAddr.new(String(ip)), Integer(port))
      @socket.connect(callback(:on_connect))
    end

    def sockname
      sockaddr, len = get_sockaddr_and_len
      check_result! UV.tcp_getsockname(handle, sockaddr, len)
      get_ip_and_port(UV::Sockaddr.new(sockaddr), len.get_int(0))
    end

    def peername
      sockaddr, len = get_sockaddr_and_len
      check_result! UV.tcp_getpeername(handle, sockaddr, len)
      get_ip_and_port(UV::Sockaddr.new(sockaddr), len.get_int(0))
    end

    def enable_nodelay
      check_result! UV.tcp_nodelay(handle, 1)
    end

    def disable_nodelay
      check_result! UV.tcp_nodelay(handle, 0)
    end

    def enable_keepalive(delay)
      check_result! UV.tcp_keepalive(handle, 1, Integer(delay))
    end

    def disable_keepalive
      check_result! UV.tcp_keepalive(handle, 0, 0)
    end

    def enable_simultaneous_accepts
      check_result! UV.tcp_simultaneous_accepts(handle, 1)
    end

    def disable_simultaneous_accepts
      check_result! UV.tcp_simultaneous_accepts(handle, 0)
    end

    private
    def create_socket(ip, port)
      if ip.ipv4?
        Socket4.new(@loop, handle, ip.to_s, port)
      else
        Socket6.new(@loop, handle, ip.to_s, port)
      end
    end

    def on_connect(req, status)
      UV.free(req)
      @connect_block.call(check_result(status))
    end

    module SocketMethods
      include Resource

      def initialize(loop, tcp, ip, port)
        @loop, @tcp, @sockaddr = loop, tcp, ip_addr(ip, port)
      end

      def bind
        check_result! tcp_bind
      end

      def connect(callback)
        check_result! tcp_connect(callback)
      end

      private

      def connect_req
        UV.create_request(:uv_connect)
      end
    end

    class Socket4
      include SocketMethods

      private
      def ip_addr(ip, port)
        UV.ip4_addr(ip, port)
      end

      def tcp_bind
        UV.tcp_bind(@tcp, @sockaddr)
      end

      def tcp_connect(callback)
        UV.tcp_connect(
          connect_req,
          @tcp,
          @sockaddr,
          callback
        )
      end
    end

    class Socket6
      include SocketMethods

      private
      def ip_addr(ip, port)
        UV.ip6_addr(ip, port)
      end

      def tcp_bind
        UV.tcp_bind6(@tcp, @sockaddr)
      end

      def tcp_connect(callback)
        UV.tcp_connect6(
          connect_req,
          @tcp,
          @sockaddr,
          callback
        )
      end
    end
  end
end