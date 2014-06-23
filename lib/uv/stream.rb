module UV
  module Stream
    include Handle

    def listen(backlog, &block)
      assert_block(block)
      assert_arity(1, block)
      assert_type(Integer, backlog, "backlog must be an Integer")

      @listen_block = block

      check_result! UV.listen(handle, Integer(backlog), callback(:on_listen))

      self
    end

    def accept
      client = loop.send(handle_name)

      check_result! UV.accept(handle, client.handle)

      client
    end

    def start_read(&block)
      assert_block(block)
      assert_arity(2, block)

      @read_block = block

      check_result! UV.read_start(handle, callback(:on_allocate), callback(:on_read))

      self
    end

    def stop_read
      check_result! UV.read_stop(handle)

      @read_block = nil

      self
    end

    def write(data, &block)
      assert_block(block)
      assert_arity(1, block)
      assert_type(String, data, "data must be a String")

      @write_block = block
      size         = data.respond_to?(:bytesize) ? data.bytesize : data.size
      buffer       = UV.buf_init(FFI::MemoryPointer.from_string(data), size)

      check_result! UV.write(UV.create_request(:uv_write), handle, buffer, 1, callback(:on_write))

      self
    end

    def shutdown(&block)
      assert_block(block)
      assert_arity(1, block)

      @shutdown_block = block

      check_result! UV.shutdown(UV.create_request(:uv_shutdown), handle, callback(:on_shutdown))

      self
    end

    def readable?
      UV.is_readable(handle) > 0
    end

    def writable?
      UV.is_writable(handle) > 0
    end

    private

    def on_listen(server, status)
      @listen_block.call(check_result(status))
    end

    def on_allocate(client, suggested_size)
      UV.buf_init(UV.malloc(suggested_size), suggested_size)
    end

    def on_read(handle, nread, buf)
      base = buf[:base]

      if nread < 0
        e = @loop.lookup_error(@loop.last_error)
        UV.free(base) if base
        @read_block.call(e, nil)
      elsif nread == 0
        UV.free(base) if base
      else
        base       = UV.realloc(base, nread)
        data       = base.read_string(nread)
        buf[:base] = base
        @read_block.call(nil, data)
      end
    end

    def on_write(req, status)
      UV.free(req)
      @write_block.call(check_result(status))
      @write_block = nil
    end

    def on_shutdown(req, status)
      UV.free(req)
      @shutdown_block.call(check_result(status))
      @shutdown_block = nil
    end

    def on_close(pointer)
      super
      @listen_block = nil if @listen_block
      @read_block   = nil if @read_block
    end
  end
end