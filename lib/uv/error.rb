module UV
  class Error < ::SystemCallError
    class UNKNOWN < Error; end
    class OK < Error; end
    class EOF < ::EOFError; end
    class EADDRINFO < Error; end
    class EACCES < ::Errno::EACCES; end
    class EAGAIN < ::Errno::EAGAIN; end
    class EADDRINUSE < ::Errno::EADDRINUSE; end
    class EADDRNOTAVAIL < ::Errno::EADDRNOTAVAIL; end
    class EAFNOSUPPORT < ::Errno::EAFNOSUPPORT; end
    class EALREADY < ::Errno::EALREADY; end
    class EBADF < ::Errno::EBADF; end
    class EBUSY < ::Errno::EBUSY; end
    class ECONNABORTED < ::Errno::ECONNABORTED; end
    class ECONNREFUSED < ::Errno::ECONNREFUSED; end
    class ECONNRESET < ::Errno::ECONNRESET; end
    class EDESTADDRREQ < ::Errno::EDESTADDRREQ; end
    class EFAULT < ::Errno::EFAULT; end
    class EHOSTUNREACH < ::Errno::EHOSTUNREACH; end
    class EINTR < ::Errno::EINTR; end
    class EINVAL < ::Errno::EINVAL; end
    class EISCONN < ::Errno::EISCONN; end
    class EMFILE < ::Errno::EMFILE; end
    class EMSGSIZE < ::Errno::EMSGSIZE; end
    class ENETDOWN < ::Errno::ENETDOWN; end
    class ENETUNREACH < ::Errno::ENETUNREACH; end
    class ENFILE < ::Errno::ENFILE; end
    class ENOBUFS < ::Errno::ENOBUFS; end
    class ENOMEM < ::Errno::ENOMEM; end
    class ENOTDIR < ::Errno::ENOTDIR; end
    class EISDIR < ::Errno::EISDIR; end
    class ENONET < ::Errno::ENONET; end
    class ENOTCONN < ::Errno::ENOTCONN; end
    class ENOTSOCK < ::Errno::ENOTSOCK; end
    class ENOTSUP < ::Errno::ENOTSUP; end
    class ENOENT < ::Errno::ENOENT; end
    class ENOSYS < ::Errno::ENOSYS; end
    class EPIPE < ::Errno::EPIPE; end
    class EPROTO < ::Errno::EPROTO; end
    class EPROTONOSUPPORT < ::Errno::EPROTONOSUPPORT; end
    class EPROTOTYPE < ::Errno::EPROTOTYPE; end
    class ETIMEDOUT < ::Timeout::Error; end
    class ECHARSE < Error; end
    class EAIFAMNOSUPPORT < Error; end
    class EAISERVICE < Error; end
    class EAISOCKTYPE < Error; end
    class ESHUTDOWN < ::Errno::ESHUTDOWN; end
    class EEXIST < ::Errno::EEXIST; end
    class ESRCH < ::Errno::ESRCH; end
    class ENAMETOOLONG < ::Errno::ENAMETOOLONG; end
    class EPERM < ::Errno::EPERM; end
    class ELOOP < ::Errno::ELOOP; end
    class EXDEV < ::Errno::EXDEV; end
    class ENOTEMPTY < ::Errno::ENOTEMPTY; end
    class ENOSPC < ::Errno::ENOSPC; end
  end
end
