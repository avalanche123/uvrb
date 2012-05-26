module UV
  class UvBuf < FFI::Struct
    layout :base, :pointer, :len, :size_t
  end

  class UvFSStat < FFI::Struct
    layout :st_dev, :dev_t, :st_ino, :ino_t, :st_mode, :mode_t, :st_nlink, :nlink_t,
    :st_uid, :uid_t, :st_gid, :gid_t, :st_rdev, :dev_t, :st_size, :off_t,
    :st_blksize, :blksize_t, :st_blocks, :blkcnt_t, :st_atime, :time_t,
    :st_mtime, :time_t, :st_ctime, :time_t
  end
end