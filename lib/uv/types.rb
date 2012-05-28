module FFI::Platform
  def self.linux?
    IS_LINUX
  end
end

module UV
  require 'uv/types/linux.rb' if FFI::Platform.linux?
  require 'uv/types/unix.rb' if FFI::Platform.unix?
  require 'uv/types/windows.rb' if FFI::Platform.windows?

  enum :uv_handle_type, [
    :uv_unknown_handle, 0,
    :uv_async,
    :uv_check,
    :uv_fs_event,
    :uv_idle,
    :uv_pipe,
    :uv_poll,
    :uv_prepare,
    :uv_process,
    :uv_tcp,
    :uv_timer,
    :uv_tty,
    :uv_udp,
    :uv_ares_task,
    :uv_file,
    :uv_handle_type_max
  ]
  enum :uv_req_type, [
    :uv_unknown_req, 0,
    :uv_connect,
    :uv_write,
    :uv_shutdown,
    :uv_udp_send,
    :uv_fs,
    :uv_work,
    :uv_getaddrinfo,
    :uv_req_type_private,
    :uv_req_type_max
  ]
  enum :uv_membership, [
    :uv_leave_group, 0,
    :uv_join_group
  ]
  enum :uv_err_code, [
    :UNKNOWN, -1,
    :OK, 0,
    :EOF, 1,
    :EADDRINFO, 2,
    :EACCES, 3,
    :EAGAIN, 4,
    :EADDRINUSE, 5,
    :EADDRNOTAVAIL, 6,
    :EAFNOSUPPORT, 7,
    :EALREADY, 8,
    :EBADF, 9,
    :EBUSY, 10,
    :ECONNABORTED, 11,
    :ECONNREFUSED, 12,
    :ECONNRESET, 13,
    :EDESTADDRREQ, 14,
    :EFAULT, 15,
    :EHOSTUNREACH, 16,
    :EINTR, 17,
    :EINVAL, 18,
    :EISCONN, 19,
    :EMFILE, 20,
    :EMSGSIZE, 21,
    :ENETDOWN, 22,
    :ENETUNREACH, 23,
    :ENFILE, 24,
    :ENOBUFS, 25,
    :ENOMEM, 26,
    :ENOTDIR, 27,
    :EISDIR, 28,
    :ENONET, 29,
    :ENOTCONN, 31,
    :ENOTSOCK, 32,
    :ENOTSUP, 33,
    :ENOENT, 34,
    :ENOSYS, 35,
    :EPIPE, 36,
    :EPROTO, 37,
    :EPROTONOSUPPORT, 38,
    :EPROTOTYPE, 39,
    :ETIMEDOUT, 40,
    :ECHARSET, 41,
    :EAIFAMNOSUPPORT, 42,
    :EAISERVICE, 44,
    :EAISOCKTYPE, 45,
    :ESHUTDOWN, 46,
    :EEXIST, 47,
    :ESRCH, 48,
    :ENAMETOOLONG, 49,
    :EPERM, 50,
    :ELOOP, 51,
    :EXDEV, 52,
    :ENOTEMPTY, 53,
    :ENOSPC, 54,
    :EIO, 55,
    :EROFS, 56,
    :UV_MAX_ERRORS
  ]
  enum :uv_fs_type, [
    :UV_FS_UNKNOWN, -1,
    :UV_FS_CUSTOM,
    :UV_FS_OPEN,
    :UV_FS_CLOSE,
    :UV_FS_READ,
    :UV_FS_WRITE,
    :UV_FS_SENDFILE,
    :UV_FS_STAT,
    :UV_FS_LSTAT,
    :UV_FS_FSTAT,
    :UV_FS_FTRUNCATE,
    :UV_FS_UTIME,
    :UV_FS_FUTIME,
    :UV_FS_CHMOD,
    :UV_FS_FCHMOD,
    :UV_FS_FSYNC,
    :UV_FS_FDATASYNC,
    :UV_FS_UNLINK,
    :UV_FS_RMDIR,
    :UV_FS_MKDIR,
    :UV_FS_RENAME,
    :UV_FS_READDIR,
    :UV_FS_LINK,
    :UV_FS_SYMLINK,
    :UV_FS_READLINK,
    :UV_FS_CHOWN,
    :UV_FS_FCHOWN
  ]
  enum :uv_fs_event, [
    :UV_RENAME, 1,
    :UV_CHANGE, 2
  ]

  typedef UvBuf.by_value, :uv_buf_t
  typedef UvFSStat.by_value, :uv_fs_stat_t

  class UvErr < FFI::Struct
    layout :code, :uv_err_code,
           :sys_errno_, :int
  end

  typedef UvErr.by_value, :uv_err_t

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

  typedef SockaddrIn.by_value, :sockaddr_in

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

  typedef SockaddrIn6.by_value, :sockaddr_in6

  typedef :pointer, :uv_handle_t
  typedef :pointer, :uv_fs_event_t
  typedef :pointer, :uv_stream_t
  typedef :pointer, :uv_tcp_t
  typedef :pointer, :uv_udp_t
  typedef :pointer, :uv_tty_t
  typedef :pointer, :uv_pipe_t
  typedef :pointer, :uv_prepare_t
  typedef :pointer, :uv_check_t
  typedef :pointer, :uv_idle_t
  typedef :pointer, :uv_async_t
  typedef :pointer, :uv_timer_t
  typedef :pointer, :uv_process_t
  typedef :pointer, :uv_getaddrinfo_cb
  typedef :pointer, :addrinfo
  typedef :pointer, :uv_fs_t
  typedef :pointer, :uv_work_t
  typedef :pointer, :uv_loop_t
  typedef :pointer, :uv_shutdown_t
  typedef :pointer, :uv_write_t
  typedef :pointer, :uv_connect_t
  typedef :pointer, :uv_udp_send_t
  typedef :int,     :uv_file
  typedef :pointer, :ares_channel
  typedef :pointer, :ares_options
  typedef :pointer, :uv_getaddrinfo_t
  typedef :pointer, :uv_options_t
  typedef :pointer, :uv_cpu_info_t
  typedef :pointer, :uv_interface_address_t
  typedef :pointer, :uv_fs_t
  typedef :pointer, :uv_lib_t
  typedef :pointer, :uv_mutex_t
  typedef :pointer, :uv_rwlock_t
  typedef :pointer, :uv_once_t
  typedef :pointer, :uv_thread_t
  typedef :int,     :status

  callback :uv_alloc_cb,       [:uv_handle_t, :size_t],                            :uv_buf_t
  callback :uv_read_cb,        [:uv_stream_t, :ssize_t, :uv_buf_t],                :void
  callback :uv_read2_cb,       [:uv_pipe_t, :ssize_t, :uv_buf_t, :uv_handle_type], :void
  callback :uv_write_cb,       [:uv_write_t, :status],                             :void
  callback :uv_connect_cb,     [:uv_connect_t, :status],                           :void
  callback :uv_shutdown_cb,    [:uv_shutdown_t, :status],                          :void
  callback :uv_connection_cb,  [:uv_stream_t, :status],                            :void
  callback :uv_close_cb,       [:uv_handle_t],                                     :void
  callback :uv_timer_cb,       [:uv_timer_t, :status],                             :void
  callback :uv_async_cb,       [:uv_async_t, :status],                             :void
  callback :uv_prepare_cb,     [:uv_prepare_t, :status],                           :void
  callback :uv_check_cb,       [:uv_check_t, :status],                             :void
  callback :uv_idle_cb,        [:uv_idle_t, :status],                              :void
  callback :uv_getaddrinfo_cb, [:uv_getaddrinfo_t, :status, :addrinfo],            :void
  callback :uv_exit_cb,        [:uv_process_t, :int, :int],                        :void
  callback :uv_fs_cb,          [:uv_fs_t],                                         :void
  callback :uv_work_cb,        [:uv_work_t],                                       :void
  callback :uv_after_work_cb,  [:uv_work_t],                                       :void
  callback :uv_fs_event_cb,    [:uv_fs_event_t, :string, :int, :int],              :void
  callback :uv_udp_send_cb,    [:uv_udp_send_t, :int],                             :void
  callback :uv_udp_recv_cb,    [:uv_udp_t, :ssize_t, :uv_buf_t, :pointer, :uint],  :void
  callback :uv_cb,             [],                                                 :void
end