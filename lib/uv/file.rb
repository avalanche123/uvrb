module UV
  class File
    include Resource, Listener

    def initialize(loop, io)
      @loop = loop
      @fd = Integer(io.fileno)
    end

    def close(&block)
      @close_block = block
      check_result! UV.fs_close(
        loop.to_ptr,
        UV.create_request(:uv_fs),
        @fd,
        callback(:on_close)
      )
    end

    def read(length, offset = 0, &block)
      raise "no block given" unless block_given?
      @read_block = block
      @read_buffer_length = Integer(length)
      @read_buffer = FFI::MemoryPointer.new(@read_buffer_length)
      check_result! UV.fs_read(
        loop.to_ptr,
        UV.create_request(:uv_fs),
        @fd,
        @read_buffer,
        @read_buffer_length,
        offset,
        callback(:on_read)
      )
    end

    def write(data, offset = 0, &block)
      @write_block = block
      @write_buffer_length = data.respond_to?(:bytesize) ? data.bytesize : data.size
      @write_buffer = FFI::MemoryPointer.from_string(data)
      check_result! UV.fs_write(
        loop.to_ptr,
        UV.create_request(:uv_fs),
        @fd,
        @write_buffer,
        @write_buffer_length,
        Integer(offset),
        callback(:on_write)
      )
    end

    def stat(&block)
      raise "no block given" unless block_given?
      @stat_block = block
      check_result! UV.fs_fstat(
        loop.to_ptr,
        UV.create_request(:uv_fs),
        @fd,
        callback(:on_stat)
      )
    end

    def sync(&block)
    end

    def datasync(&block)
    end

    def truncate(offset, &block)
    end

    def utime(atime, mtime, &block)
    end

    def chmod(mode, &block)
    end

    def chown(uid, gid, &block)
    end

    private

    def on_close(req)
      UV.fs_req_cleanup(req)
      UV.free(req)
      @close_block.call if @close_block
    end

    def on_read(req)
      UV.fs_req_cleanup(req)
      UV.free(req)
      data = @read_buffer.read_string(@read_buffer_length)
      @read_buffer = nil
      @read_buffer_length = nil
      @read_block.call(data)
    end

    def on_write(req)
      UV.fs_req_cleanup(req)
      UV.free(req)
      @write_buffer = nil
      @write_buffer_length = nil
      @write_block.call if @write_block
    end

    def on_stat(req)
    end
  end
end