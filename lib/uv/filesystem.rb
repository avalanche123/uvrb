module UV
  class Filesystem
    include Assertions, Resource, Listener

    def initialize(loop)
      @loop = loop
    end

    def open(path, flags = 0, mode = 0, &block)
      assert_block(block)
      assert_arity(2, block)
      assert_type(String, path, "path must be a String")
      assert_type(Integer, flags, "flags must be an Integer")
      assert_type(Integer, mode, "mode must be an Integer")

      @open_block = block

      check_result! UV.fs_open(loop.to_ptr, UV.create_request(:uv_fs), path, flags, mode, callback(:on_open))

      self
    end

    def unlink(path, &block)
      assert_block(block)
      assert_arity(1, block)
      assert_type(String, path, "path must be a String")

      @unlink_block = block

      check_result! UV.fs_unlink(loop.to_ptr, UV.create_request(:uv_fs), path, callback(:on_unlink))

      self
    end

    def mkdir(path, mode = 0777, &block)
      assert_block(block)
      assert_arity(1, block)
      assert_type(String, path, "path must be a String")
      assert_type(Integer, mode, "mode must be an Integer")

      @mkdir_block = block

      check_result! UV.fs_mkdir(loop.to_ptr, UV.create_request(:uv_fs), path, mode, callback(:on_mkdir))

      self
    end

    def rmdir(path, &block)
      assert_block(block)
      assert_arity(1, block)
      assert_type(String, path, "path must be a String")

      @rmdir_block = block

      check_result! UV.fs_rmdir(loop.to_ptr, UV.create_request(:uv_fs), path, callback(:on_rmdir))

      self
    end

    def readdir(path, &block)
      assert_block(block)
      assert_arity(2, block)
      assert_type(String, path, "path must be a String")

      @readdir_block = block

      check_result! UV.fs_readdir(loop.to_ptr, UV.create_request(:uv_fs), path, 0, callback(:on_readdir))

      self
    end

    def stat(path, &block)
      assert_block(block)
      assert_arity(2, block)
      assert_type(String, path, "path must be a String")

      @stat_block = block

      check_result! UV.fs_stat(loop.to_ptr, UV.create_request(:uv_fs), path, callback(:on_stat))

      self
    end

    def rename(old_path, new_path, &block)
      assert_block(block)
      assert_arity(1, block)
      assert_type(String, old_path, "old_path must be a String")
      assert_type(String, new_path, "new_path must be a String")

      @rename_block = block

      check_result! UV.fs_rename(loop.to_ptr, UV.create_request(:uv_fs), old_path, new_path, callback(:on_rename))

      self
    end

    def chmod(path, mode, &block)
      assert_block(block)
      assert_arity(1, block)
      assert_type(String, path, "path must be a String")
      assert_type(Integer, mode, "mode must be an Integer")

      @chmod_block = block

      check_result! UV.fs_chmod(loop.to_ptr, UV.create_request(:uv_fs), path, mode, callback(:on_chmod))

      self
    end

    def utime(path, atime, mtime, &block)
      assert_block(block)
      assert_arity(1, block)
      assert_type(String, path, "path must be a String")
      assert_type(Integer, atime, "atime must be an Integer")
      assert_type(Integer, mtime, "mtime must be an Integer")

      @utime_block = block

      check_result! UV.fs_utime(loop.to_ptr, UV.create_request(:uv_fs), path, atime, mtime, callback(:on_utime))

      self
    end

    def lstat(path, &block)
      assert_block(block)
      assert_arity(2, block)
      assert_type(String, path, "path must be a String")

      @lstat_block = block

      check_result! UV.fs_lstat(loop.to_ptr, UV.create_request(:uv_fs), path, callback(:on_lstat))

      self
    end

    def link(old_path, new_path, &block)
      assert_block(block)
      assert_arity(1, block)
      assert_type(String, old_path, "old_path must be a String")
      assert_type(String, new_path, "new_path must be a String")

      @link_block = block

      check_result! UV.fs_link(loop.to_ptr, UV.create_request(:uv_fs), old_path, new_path, callback(:on_link))

      self
    end

    def symlink(old_path, new_path, &block)
      assert_block(block)
      assert_arity(1, block)
      assert_type(String, old_path, "old_path must be a String")
      assert_type(String, new_path, "new_path must be a String")

      @symlink_block = block

      check_result! UV.fs_symlink(loop.to_ptr, UV.create_request(:uv_fs), old_path, new_path, 0, callback(:on_symlink))

      self
    end

    def readlink(path, &block)
      assert_block(block)
      assert_arity(2, block)
      assert_type(String, path, "path must be a String")

      @readlink_block = block

      check_result! UV.fs_readlink(loop.to_ptr, UV.create_request(:uv_fs), path, callback(:on_readlink))

      self
    end

    def chown(path, uid, gid, &block)
      assert_block(block)
      assert_arity(1, block)
      assert_type(String, path, "path must be a String")
      assert_type(Integer, uid, "uid must be an Integer")
      assert_type(Integer, gid, "gid must be an Integer")

      @chown_block = block

      check_result! UV.fs_chown(loop.to_ptr, UV.create_request(:uv_fs), path, uid, gid, callback(:on_chown))

      self
    end

    private
    def on_open(req)
      fd   = UV.fs_req_result(req)
      e    = check_result(fd)
      file = File.new(loop, fd) unless e

      UV.fs_req_cleanup(req)
      UV.free(req)

      @open_block.call(e, file)
    end

    def on_unlink(req)
      e = check_result(UV.fs_req_result(req))

      UV.fs_req_cleanup(req)
      UV.free(req)

      @unlink_block.call(e)
    end

    def on_mkdir(req)
      e = check_result(UV.fs_req_result(req))

      UV.fs_req_cleanup(req)
      UV.free(req)

      @mkdir_block.call(e)
    end

    def on_rmdir(req)
      e = check_result(UV.fs_req_result(req))

      UV.fs_req_cleanup(req)
      UV.free(req)

      @rmdir_block.call(e)
    end

    def on_readdir(req)
      e = check_result(UV.fs_req_result(req))

      unless e
        string_ptr = UV.fs_req_pointer(req)
        files = string_ptr.null? ? [] : string_ptr.read_string().split("\0")
      end

      UV.fs_req_cleanup(req)
      UV.free(req)

      @readdir_block.call(e, files)
    end

    def on_stat(req)
      e = check_result(UV.fs_req_result(req))

      unless e
        uv_stat    = UV.fs_req_stat(req)
        uv_members = uv_stat.members

        values = Stat.members.map { |k| uv_members.include?(k) ? uv_stat[k] : nil }

        stat = Stat.new(*values)
      end

      UV.fs_req_cleanup(req)
      UV.free(req)

      @stat_block.call(e, stat)
    end

    def on_rename(req)
      e = check_result(UV.fs_req_result(req))

      UV.fs_req_cleanup(req)
      UV.free(req)

      @rename_block.call(e)
    end

    def on_chmod(req)
      e = check_result(UV.fs_req_result(req))

      UV.fs_req_cleanup(req)
      UV.free(req)

      @chmod_block.call(e)
    end

    def on_utime(req)
      e = check_result(UV.fs_req_result(req))

      UV.fs_req_cleanup(req)
      UV.free(req)

      @utime_block.call(e)
    end

    def on_lstat(req)
      e = check_result(UV.fs_req_result(req))

      unless e
        uv_stat    = UV.fs_req_stat(req)
        uv_members = uv_stat.members

        values = Stat.members.map { |k| uv_members.include?(k) ? uv_stat[k] : nil }

        stat = Stat.new(*values)
      end

      UV.fs_req_cleanup(req)
      UV.free(req)

      @lstat_block.call(e, stat)
    end

    def on_link(req)
      e = check_result(UV.fs_req_result(req))

      UV.fs_req_cleanup(req)
      UV.free(req)

      @link_block.call(e)
    end

    def on_symlink(req)
      e = check_result(UV.fs_req_result(req))

      UV.fs_req_cleanup(req)
      UV.free(req)

      @symlink_block.call(e)
    end

    def on_readlink(req)
      e = check_result(UV.fs_req_result(req))

      unless e
        string_ptr = UV.fs_req_pointer(req)
        path = string_ptr.read_string() unless string_ptr.null?
      end

      UV.fs_req_cleanup(req)
      UV.free(req)

      @readlink_block.call(e, path)
    end

    def on_chown(req)
      e = check_result(UV.fs_req_result(req))

      UV.fs_req_cleanup(req)
      UV.free(req)

      @chown_block.call(e)
    end
  end
end