module UV
  class UDP
    include Handle, Net

    def bind(ip, port, ipv6_only = false)
      assert_type(String, ip, "ip must be a String")
      assert_type(Integer, port, "port must be an Integer")
      assert_boolean(ipv6_only, "ipv6_only must be a Boolean")

      @socket = create_socket(IPAddr.new(ip), port)
      @socket.bind(ipv6_only)

      self
    end

    def sockname
      sockaddr, len = get_sockaddr_and_len
      check_result! UV.udp_getsockname(handle, sockaddr, len)
      get_ip_and_port(UV::Sockaddr.new(sockaddr), len.get_int(0))
    end

    def join(multicast_address, interface_address)
      assert_type(String, multicast_address, "multicast_address must be a String")
      assert_type(String, interface_address, "interface_address must be a String")

      check_result! UV.udp_set_membership(handle, multicast_address, interface_address, :uv_join_group)

      self
    end

    def leave(multicast_address, interface_address)
      assert_type(String, multicast_address, "multicast_address must be a String")
      assert_type(String, interface_address, "interface_address must be a String")

      check_result! UV.udp_set_membership(handle, multicast_address, interface_address, :uv_leave_group)

      self
    end

    def start_recv(&block)
      assert_block(block)
      assert_arity(4, block)

      @recv_block = block

      check_result! UV.udp_recv_start(handle, callback(:on_allocate), callback(:on_recv))

      self
    end

    def stop_recv
      check_result! UV.udp_recv_stop(handle)
    end

    def send(ip, port, data, &block)
      assert_block(block)
      assert_arity(1, block)
      assert_type(String, ip, "ip must be a String")
      assert_type(Integer, port, "port must be an Integer")
      assert_type(String, data, "data must be a String")

      @send_block = block

      @socket = create_socket(IPAddr.new(ip), port)
      @socket.send(data, callback(:on_send))

      self
    end

    def enable_multicast_loop
      check_result! UV.udp_set_multicast_loop(handle, 1)

      self
    end

    def disable_multicast_loop
      check_result! UV.udp_set_multicast_loop(handle, 0)

      self
    end

    def multicast_ttl=(ttl)
      assert_type(Integer, ttl, "ttl must be an Integer")

      check_result! UV.udp_set_multicast_ttl(handle, ttl)

      self
    end

    def enable_broadcast
      check_result! UV.udp_set_broadcast(handle, 1)

      self
    end

    def disable_broadcast
      check_result! UV.udp_set_broadcast(handle, 0)

      self
    end

    def ttl=(ttl)
      assert_type(Integer, ttl, "ttl must be an Integer")

      check_result! UV.udp_set_ttl(handle, Integer(ttl))

      self
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
      unless sockaddr.null?
        ip, port = get_ip_and_port(UV::Sockaddr.new(sockaddr))
      end
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