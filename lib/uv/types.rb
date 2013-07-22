module FFI::Platform
  def self.linux?
    IS_LINUX
  end
end

module UV
  require 'uv/types/linux.rb' if FFI::Platform.linux?
  require 'uv/types/unix.rb' if FFI::Platform.unix?
  require 'uv/types/darwin_x64.rb' if FFI::Platform.mac? and FFI::Platform::ARCH == 'x86_64'
  require 'uv/types/windows.rb' if FFI::Platform.windows?

  enum :uv_handle_type, [
    :uv_unknown_handle, 0,
    :uv_async, # start UV_HANDLE_TYPE_MAP
    :uv_check,
    :uv_fs_event,
    :uv_fs_poll,
    :uv_handle,
    :uv_idle,
    :uv_pipe,
    :uv_poll,
    :uv_prepare,
    :uv_process,
    :uv_stream,
    :uv_tcp,
    :uv_timer,
    :uv_tty,
    :uv_udp,
    :uv_signal, # end UV_HANDLE_TYPE_MAP
    :uv_file,
    :uv_handle_type_max
  ]
  enum :uv_req_type, [
    :uv_unknown_req, 0,
    :uv_req,         # start UV_REQ_TYPE_MAP
    :uv_connect,
    :uv_write,
    :uv_shutdown,
    :uv_udp_send,
    :uv_fs,
    :uv_work,
    :uv_getaddrinfo, # end UV_REQ_TYPE_MAP
    :uv_req_type_private,
    :uv_req_type_max
  ]
  enum :uv_membership, [
    :uv_leave_group, 0,
    :uv_join_group
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
  enum :uv_run_mode, [
    :UV_RUN_DEFAULT, 0,
    :UV_RUN_ONCE,
    :UV_RUN_NOWAIT
  ]

  typedef UvBuf.by_value, :uv_buf_t
  typedef UvFSStat.by_value, :uv_fs_stat_t


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


  class UvTimespec < FFI::Struct
    layout  :tv_sec,  :long,
            :tv_nsec, :long
  end

  class UvStat < FFI::Struct
    layout  :st_dev,      :uint64,
            :st_mode,     :uint64,
            :st_nlink,    :uint64,
            :st_uid,      :uint64,
            :st_gid,      :uint64,
            :st_rdev,     :uint64,
            :st_ino,      :uint64,
            :st_size,     :uint64,
            :st_blksize,  :uint64,
            :st_blocks,   :uint64,
            :st_flags,    :uint64,
            :st_gen,      :uint64,
            :st_atim,     UvTimespec,
            :st_mtim,     UvTimespec,
            :st_ctim,     UvTimespec,
            :st_birthtim, UvTimespec
  end

  typedef UvStat.by_value, :uv_stat_t

  typedef :pointer, :uv_handle_t
  typedef :pointer, :uv_fs_event_t
  typedef :pointer, :uv_fs_poll_t
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
  typedef :pointer, :uv_poll_t
  typedef :pointer, :uv_stat_t
  typedef :int,     :status
  typedef :int,     :events

  callback :uv_alloc_cb,       [:uv_handle_t, :size_t],                            :uv_buf_t
  callback :uv_read_cb,        [:uv_stream_t, :ssize_t, :uv_buf_t],                :void
  callback :uv_read2_cb,       [:uv_pipe_t, :ssize_t, :uv_buf_t, :uv_handle_type], :void
  callback :uv_write_cb,       [:uv_write_t, :status],                             :void
  callback :uv_connect_cb,     [:uv_connect_t, :status],                           :void
  callback :uv_shutdown_cb,    [:uv_shutdown_t, :status],                          :void
  callback :uv_connection_cb,  [:uv_stream_t, :status],                            :void
  callback :uv_close_cb,       [:uv_handle_t],                                     :void
  callback :uv_poll_cb,        [:uv_poll_t, :status, :events],                     :void
  callback :uv_timer_cb,       [:uv_timer_t, :status],                             :void
  callback :uv_async_cb,       [:uv_async_t, :status],                             :void
  callback :uv_prepare_cb,     [:uv_prepare_t, :status],                           :void
  callback :uv_check_cb,       [:uv_check_t, :status],                             :void
  callback :uv_idle_cb,        [:uv_idle_t, :status],                              :void
  callback :uv_getaddrinfo_cb, [:uv_getaddrinfo_t, :status, :addrinfo],            :void
  callback :uv_exit_cb,        [:uv_process_t, :int, :int],                        :void
  callback :uv_walk_cb,        [:uv_handle_t, :pointer],                           :void
  callback :uv_fs_cb,          [:uv_fs_t],                                         :void
  callback :uv_work_cb,        [:uv_work_t],                                       :void
  callback :uv_after_work_cb,  [:uv_work_t],                                       :void
  callback :uv_fs_event_cb,    [:uv_fs_event_t, :string, :int, :int],              :void
  callback :uv_fs_poll_cb,     [:uv_fs_poll_t, :status, :uv_stat_t, :uv_stat_t],   :void
  #callback :uv_signal_cb,      []
  callback :uv_udp_send_cb,    [:uv_udp_send_t, :int],                             :void
  callback :uv_udp_recv_cb,    [:uv_udp_t, :ssize_t, :uv_buf_t, :pointer, :uint],  :void
  callback :uv_cb,             [],                                                 :void
end