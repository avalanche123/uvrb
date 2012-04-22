module UV
  class File
    include Resource, Listener

    def initialize(loop, io)
      @loop = loop
      @fd = Integer(io.fileno)
    end

    def close(&block)
    end

    def read(length, offset, &block)
    end

    def write(data, &block)
    end

    def stat(&block)
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
  end
end