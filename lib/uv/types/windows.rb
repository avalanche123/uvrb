module UV
  typedef :uint32_t, :in_addr_t
  typedef :uint16, :in_port_t
  typedef :int, :mode_t
  # http://stackoverflow.com/questions/1953639/is-it-safe-to-cast-socket-to-int-under-win64
  typedef :int, :uv_os_sock_t

  module WS2
    extend FFI::Library
    ffi_lib('Ws2_32.dll').first  # this is for ntohs
    attach_function :ntohs, [:ushort], :ushort, :blocking => true
  end
  def_delegators :WS2, :ntohs
  module_function :ntohs

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