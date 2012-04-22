module UV
  class Filesystem
    def initialize(loop)
      @loop = loop
    end

    def open(path, mode, opt, &block)
    end

    def unlink(path, &block)
    end

    def mkdir(path, mode, &block)
    end

    def rmdir(path, &block)
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
  end
end