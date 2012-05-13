module UV
  class File
    class Stat < Struct.new(:atime, :blksize, :blocks, :ctime, :dev, :ftype, :gid, :ino,
                            :mode, :mtime, :nlink, :rdev, :size, :uid)
      def blockdev?; end
      def chardev?; end
      def dev_major; end
      def dev_minor; end
      def directory?; end
      def executable?; end
      def executable_real?; end
      def file?; end
      def ftype; end
      def grpowned?; end
      def inspect; end
      def owned?; end
      def pipe?; end
      def rdev_major; end
      def rdev_minor; end
      def readable?; end
      def readable_real?; end
      def setgid?; end
      def setuid?; end
      def size?; end
      def socket?; end
      def sticky?; end
      def symlink?; end
      def world_readable?; end
      def world_writeable?; end
      def writable?; end
      def writable_real?; end
      def zero?; end
    end
  end
end