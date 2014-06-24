module UV
  class UvFSStat < FFI::Struct
    layout :st_dev, :dev_t, :st_mode, :mode_t, :st_nlink, :nlink_t,
    :st_ino, :ino_t, :st_uid, :uid_t, :st_gid, :gid_t, :st_rdev,
    :dev_t, :st_atime, :time_t, :st_mtime, :time_t, :st_ctime,
    :time_t, :st_size, :off_t, :st_blocks, :blkcnt_t, :st_blksize,
    :blksize_t, :st_flags, :uint32, :st_gen, :uint32, :st_lspare,
    :int32, :st_qspare_0, :int64, :st_qspare_1, :int64
  end

  class Sockaddr < FFI::Struct
    layout :sa_len, :uint8,
           :sa_family, :sa_family_t,
           :sa_data, [:char, 14]
  end

  class InAddr < FFI::Struct
    layout :s_addr, :in_addr_t
  end

  class SockaddrIn < FFI::Struct
    layout :sin_len, :uint8,
           :sin_family, :sa_family_t,
           :sin_port, :in_port_t,
           :sin_addr, InAddr,
           :sin_zero, [:char, 8]
  end

  class U6Addr < FFI::Union
    layout :__u6_addr8, [:uint8, 16],
           :__u6_addr16, [:uint16, 8]
  end

  class In6Addr < FFI::Struct
    layout :__u6_addr, U6Addr
  end

  class SockaddrIn6 < FFI::Struct
    layout :sin6_len, :uint8,
           :sin6_family, :sa_family_t,
           :sin6_port, :in_port_t,
           :sin6_flowinfo, :uint32,
           :sin6_addr, In6Addr,
           :sin6_scope_id, :uint32
  end
end
