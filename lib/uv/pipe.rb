module UV
  class Pipe
    include Stream

    def open(fileno)
      assert_type(Integer, fileno, "io#fileno must return an integer file descriptor")

      check_result! UV.pipe_open(handle, fileno)

      self
    end

    def bind(name)
      assert_type(String, name, "name must be a String")

      name = windows_path name if FFI::Platform.windows?
      check_result! UV.pipe_bind(handle, name)

      self
    end

    def connect(name, &block)
      assert_block(block)
      assert_arity(1, block)
      assert_type(String, name, "name must be a String")

      @connect_block = block

      name = windows_path name if FFI::Platform.windows?
      UV.pipe_connect(UV.create_request(:uv_connect), handle, name, callback(:on_connect))

      self
    end

    def pending_instances=(count)
      assert_type(Integer, count, "count must be an Integer")

      UV.pipe_pending_instances(handle, count)

      self
    end

    private
    def on_connect(req, status)
      UV.free(req)
      @connect_block.call(check_result(status))
    end

    def windows_path(name)
      # test for \\\\.\\pipe
      if not name =~ /(\/|\\){2}\.(\/|\\)pipe/i
        name = ::File.join("\\\\.\\pipe", name)
      end
      name.gsub("/", "\\")
    end
  end
end