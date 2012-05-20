module UV
  class UDP
    include Handle, Resource, Listener, Net

    def bind(ip, port, ipv6_only = false)
      @socket = create_socket(IPAddr.new(String(ip)), Integer(port))
      @socket.bind(ipv6_only)
    end

    def sockname
      sockaddr, len = get_sockaddr_and_len
      check_result! UV.udp_getsockname(handle, sockaddr, len)
      get_ip_and_port(UV::Sockaddr.new(sockaddr), len.get_int(0))
    end

    def join(multicast_address, interface_address)
      check_result! UV.udp_set_membership(handle, String(multicast_address), String(interface_address), :uv_join_group)
    end

    def leave(multicast_address, interface_address)
      check_result! UV.udp_set_membership(handle, String(multicast_address), String(interface_address), :uv_leave_group)
    end

    def start_recv(&block)
      raise ArgumentError, "no block given", caller unless block_given?
      @recv_block = block
      check_result! UV.udp_recv_start(handle, callback(:on_allocate), callback(:on_recv))
    end

    def stop_recv
      check_result! UV.udp_recv_stop(handle)
    end

    def send(data, &block)
      raise ArgumentError, "no block given", caller unless block_given?
      raise "cannot send data over unbound socket, make sure to #bind it first" unless @socket
      @send_block = block
      @socket.send(data, callback(:on_send))
    end

    def enable_multicast_loop
      check_result! UV.udp_set_multicast_loop(handle, 1)
    end

    def disable_multicast_loop
      check_result! UV.udp_set_multicast_loop(handle, 0)
    end

    def multicast_ttl=(ttl)
      check_result! UV.udp_set_multicast_ttl(handle, Integer(ttl))
    end

    def enable_broadcast
      check_result! UV.udp_set_broadcast(handle, 1)
    end

    def disable_broadcast
      check_result! UV.udp_set_broadcast(handle, 0)
    end

    def ttl=(ttl)
      check_result! UV.udp_set_ttl(handle, Integer(ttl))
    end

    private

    def on_allocate(client, suggested_size)
      UV.buf_init(UV.malloc(suggested_size), suggested_size)
    end

    def on_recv(handle, nread, buf, sockaddr, flags)
      e = check_result(nread)
      base = buf[:base]
      unless e
        data = base.read_string(nread)
      end
      UV.free(base)
      ip, port = get_ip_and_port(sockaddr)
      @recv_block.call(e, data, ip, port)
    end

    def on_send(req, status)
      UV.free(req)
      @send_block.call(check_result(status))
    end

    def create_socket(ip, port)
      if ip.ipv4?
        Socket4.new(@loop, handle, ip, port)
      else
        Socket6.new(@loop, handle, ip, port)
      end
    end

    module SocketMethods
      include Resource

      def initialize(loop, udp, ip, port)
        @loop, @udp, @sockaddr = loop, udp, ip_addr(ip.to_s, port)
      end

      def bind(ipv6_only = false)
        check_result! udp_bind(ipv6_only)
      end

      def send(data, callback)
        check_result! udp_send(data, callback)
      end

      private
      def send_req
        UV.create_request(:uv_udp_send)
      end

      def buf_init(data)
        UV.buf_init(FFI::MemoryPointer.from_string(data), data.respond_to?(:bytesize) ? data.bytesize : data.size)
      end
    end

    class Socket4
      include SocketMethods

      private
      def ip_addr(ip, port)
        UV.ip4_addr(ip, port)
      end

      def udp_bind(ipv6_only)
        UV.udp_bind(@udp, @sockaddr, 0)
      end

      def udp_send(data, callback)
        UV.udp_send(
          send_req,
          @udp,
          buf_init(data),
          1,
          @sockaddr,
          callback
        )
      end
    end

    class Socket6 < Socket
      include SocketMethods

      private
      def ip_addr(ip, port)
        UV.ip6_addr(ip, port)
      end

      def udp_bind(ipv6_only)
        UV.udp_bind6(@udp, @sockaddr, ipv6_only ? 1 : 0)
      end

      def udp_send(data, callback)
        UV.udp_send6(
          send_req,
          @udp,
          buf_init(data),
          1,
          @sockaddr,
          callback
        )
      end
    end
  end
end