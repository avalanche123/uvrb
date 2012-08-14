module UV
  class UvFSStat < FFI::Struct
    layout :st_dev, :dev_t, :st_mode, :mode_t, :st_nlink, :nlink_t,
    :st_ino, :ino_t, :st_uid, :uid_t, :st_gid, :gid_t, :st_rdev,
    :dev_t, :st_atime, :time_t, :st_mtime, :time_t, :st_ctime,
    :time_t, :st_size, :off_t, :st_blocks, :blkcnt_t, :st_blksize,
    :blksize_t, :st_flags, :uint32, :st_gen, :uint32, :st_lspare,
    :int32, :st_qspare_0, :int64, :st_qspare_1, :int64
  end
end
