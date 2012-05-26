module UV
  # win32 has a different uv_buf_t layout to everything else.
  class UvBuf < FFI::Struct
    layout :len, :ulong, :base, :pointer
  end

  # win32 uses _stati64
  class UvFSStat < FFI::Struct
    layout :st_gid, :gid_t, :st_atime, :time_t, :st_ctime, :time_t, :st_dev, :dev_t,
    :st_ino, :ino_t, :st_mode, :mode_t, :st_mtime, :time_t, :st_nlink, :nlink_t,
    :st_rdev, :dev_t, :st_size, :off_t, :st_uid, :uid_t
  end
end