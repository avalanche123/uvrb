module UV
  class File
    include Resource, Listener

    def initialize(loop, fd)
      @loop = loop
      @fd = Integer(fd)
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
      raise ArgumentError, "no block given", caller unless block_given?
      @read_block = block
      @read_buffer_length = Integer(length)
      @read_buffer = FFI::MemoryPointer.new(@read_buffer_length)
      check_result! UV.fs_read(
        loop.to_ptr,
        UV.create_request(:uv_fs),
        @fd,
        @read_buffer,
        @read_buffer_length,
        Integer(offset),
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
      raise ArgumentError, "no block given", caller unless block_given?
      @stat_block = block
      check_result! UV.fs_fstat(
        loop.to_ptr,
        UV.create_request(:uv_fs),
        @fd,
        callback(:on_stat)
      )
    end

    def sync(&block)
      raise ArgumentError, "no block given", caller unless block_given?
      @sync_block = block
      check_result! UV.fs_fsync(
        loop.to_ptr,
        UV.create_request(:uv_fs),
        @fd,
        callback(:on_sync)
      )
    end

    def datasync(&block)
      raise ArgumentError, "no block given", caller unless block_given?
      @datasync_block = block
      check_result! UV.fs_fdatasync(
        loop.to_ptr,
        UV.create_request(:uv_fs),
        @fd,
        callback(:on_datasync)
      )
    end

    def truncate(offset, &block)
      raise ArgumentError, "no block given", caller unless block_given?
      @truncate_block = block
      check_result! UV.fs_ftruncate(
        loop.to_ptr,
        UV.create_request(:uv_fs),
        @fd,
        Integer(offset),
        callback(:on_truncate)
      )
    end

    def utime(atime, mtime, &block)
      raise ArgumentError, "no block given", caller unless block_given?
      @utime_block = block
      check_result! UV.fs_futime(
        loop.to_ptr,
        UV.create_request(:uv_fs),
        @fd,
        Integer(atime),
        Integer(mtime),
        callback(:on_utime)
      )
    end

    def chmod(mode, &block)
      raise ArgumentError, "no block given", caller unless block_given?
      @chmod_block = block
      check_result! UV.fs_fchmod(
        loop.to_ptr,
        UV.create_request(:uv_fs),
        @fd,
        Integer(mode),
        callback(:on_chmod)
      )
    end

    def chown(uid, gid, &block)
      raise ArgumentError, "no block given", caller unless block_given?
      @chown_block = block
      check_result! UV.fs_fchown(
        loop.to_ptr,
        UV.create_request(:uv_fs),
        @fd,
        Integer(uid),
        Integer(gid),
        callback(:on_chown)
      )
    end

    private

    def on_close(req)
      e = check_result(UV.fs_req_result(req))
      UV.fs_req_cleanup(req)
      UV.free(req)
      @close_block.call(e) if @close_block
    end

    def on_read(req)
      e = check_result(UV.fs_req_result(req))
      unless e
        data = @read_buffer.read_string(@read_buffer_length)
      end
      UV.fs_req_cleanup(req)
      UV.free(req)
      @read_buffer = nil
      @read_buffer_length = nil
      @read_block.call(e, data)
    end

    def on_write(req)
      e = check_result(UV.fs_req_result(req))
      UV.fs_req_cleanup(req)
      UV.free(req)
      @write_buffer = nil
      @write_buffer_length = nil
      @write_block.call(e) if @write_block
    end

    def on_stat(req)
      e = check_result(UV.fs_req_result(req))
      unless e
        uv_stat    = UV.fs_req_stat(req)
        uv_members = uv_stat.members

        values = Stat.members.map { |k| uv_members.include?(k) ? uv_stat[k] : nil }

        stat = Stat.new(*values)
      end
      @stat_block.call(e, stat)
      UV.fs_req_cleanup(req)
      UV.free(req)
    end

    def on_sync(req)
      e = check_result(UV.fs_req_result(req))
      UV.fs_req_cleanup(req)
      UV.free(req)
      @sync_block.call(e)
    end

    def on_datasync(req)
      e = check_result(UV.fs_req_result(req))
      UV.fs_req_cleanup(req)
      UV.free(req)
      @datasync_block.call(e)
    end

    def on_truncate(req)
      e = check_result(UV.fs_req_result(req))
      UV.fs_req_cleanup(req)
      UV.free(req)
      @truncate_block.call(e)
    end

    def on_utime(req)
      e = check_result(UV.fs_req_result(req))
      UV.fs_req_cleanup(req)
      UV.free(req)
      @utime_block.call(e)
    end

    def on_chmod(req)
      e = check_result(UV.fs_req_result(req))
      UV.fs_req_cleanup(req)
      UV.free(req)
      @chmod_block.call(e)
    end

    def on_chown(req)
      e = check_result(UV.fs_req_result(req))
      UV.fs_req_cleanup(req)
      UV.free(req)
      @chown_block.call(e)
    end
  end
end