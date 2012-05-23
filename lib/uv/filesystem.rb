module UV
  class Filesystem
    include Resource, Listener, Assertions

    # :stopdoc:
    def initialize(loop)
      @loop = loop
    end
    # :startdoc:

    def open(path, mode = 0, perm = 0, &block) # :yields: error, file
      assert_block(block)
      assert_arity(2, block)
      assert_type(String, path, "path must be a String")
      assert_type(Integer, mode, "mode must be an Integer")
      assert_type(Integer, perm, "perm must be an Integer")

      @open_block = block

      UV.fs_open(loop.to_ptr, UV.create_request(:uv_fs), mode, perm, callback(:on_open))
    end

    def unlink(path, &block) # :yields: error
      assert_block(block)
      assert_arity(1, block)
      assert_type(String, path, "path must be a String")

      @unlink_block = block

      UV.fs_unlink(loop.to_ptr, UV.create_request(:uv_fs), path, callback(:on_unlink))
    end

    def mkdir(path, perm = 0777, &block) # :yields: error
      assert_block(block)
      assert_arity(1, block)
      assert_type(String, path, "path must be a String")
      assert_type(Integer, perm, "perm must be an Integer")

      @mkdir_block = block

      UV.fs_mkdir(loop.to_ptr, UV.create_request(:uv_fs), path, perm, callback(:on_mkdir))
    end

    def rmdir(path, &block) # :yields: error
      assert_block(block)
      assert_arity(1, block)
      assert_type(String, path, "path must be a String")

      @rmdir_block = block

      UV.fs_unlink(loop.to_ptr, UV.create_request(:uv_fs), path, callback(:on_rmdir))
    end

    def readdir(path, flags, &block)
    end

    def stat(path, &block)
    end

    def rename(path, new_path, &block)
    end

    def chmod(path, mode, &block)
    end

    def utime(path, atime, mtime, &block)
    end

    def lstat(path, &block)
    end

    def link(path, new_path, &block)
    end

    def symlink(path, new_path, flags, &block)
    end

    def readlink(path, &block)
    end

    def chown(path, uid, gid, &block)
    end

    # Watcher for a path
    def watch(path)
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
  end
end