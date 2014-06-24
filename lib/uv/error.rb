module UV
  module Error
    ruby_engine = defined?(RUBY_ENGINE)? RUBY_ENGINE : 'ruby'

    case ruby_engine
    when 'jruby', 'rbx'
      class ENONET < ::RuntimeError; include Error; end
      class ENOTSUP < ::RuntimeError; include Error; end
    else
      class ENONET < ::Errno::ENONET; include Error; end
      class ENOTSUP < ::Errno::ENOTSUP; include Error; end
    end

    class UNKNOWN < ::RuntimeError; include Error; end
    class OK < ::RuntimeError; include Error; end
    class EOF < ::EOFError; include Error; end
    class EADDRINFO < ::RuntimeError; include Error; end
    class EACCES < ::Errno::EACCES; include Error; end
    class EAGAIN < ::Errno::EAGAIN; include Error; end
    class EADDRINUSE < ::Errno::EADDRINUSE; include Error; end
    class EADDRNOTAVAIL < ::Errno::EADDRNOTAVAIL; include Error; end
    class EAFNOSUPPORT < ::Errno::EAFNOSUPPORT; include Error; end
    class EALREADY < ::Errno::EALREADY; include Error; end
    class EBADF < ::Errno::EBADF; include Error; end
    class EBUSY < ::Errno::EBUSY; include Error; end
    class ECONNABORTED < ::Errno::ECONNABORTED; include Error; end
    class ECONNREFUSED < ::Errno::ECONNREFUSED; include Error; end
    class ECONNRESET < ::Errno::ECONNRESET; include Error; end
    class EDESTADDRREQ < ::Errno::EDESTADDRREQ; include Error; end
    class EFAULT < ::Errno::EFAULT; include Error; end
    class EHOSTUNREACH < ::Errno::EHOSTUNREACH; include Error; end
    class EINTR < ::Errno::EINTR; include Error; end
    class EINVAL < ::Errno::EINVAL; include Error; end
    class EISCONN < ::Errno::EISCONN; include Error; end
    class EMFILE < ::Errno::EMFILE; include Error; end
    class EMSGSIZE < ::Errno::EMSGSIZE; include Error; end
    class ENETDOWN < ::Errno::ENETDOWN; include Error; end
    class ENETUNREACH < ::Errno::ENETUNREACH; include Error; end
    class ENFILE < ::Errno::ENFILE; include Error; end
    class ENOBUFS < ::Errno::ENOBUFS; include Error; end
    class ENOMEM < ::Errno::ENOMEM; include Error; end
    class ENOTDIR < ::Errno::ENOTDIR; include Error; end
    class EISDIR < ::Errno::EISDIR; include Error; end
    class ENOTCONN < ::Errno::ENOTCONN; include Error; end
    class ENOTSOCK < ::Errno::ENOTSOCK; include Error; end
    class ENOENT < ::Errno::ENOENT; include Error; end
    class ENOSYS < ::Errno::ENOSYS; include Error; end
    class EPIPE < ::Errno::EPIPE; include Error; end
    class EPROTO < ::Errno::EPROTO; include Error; end
    class EPROTONOSUPPORT < ::Errno::EPROTONOSUPPORT; include Error; end
    class EPROTOTYPE < ::Errno::EPROTOTYPE; include Error; end
    class ETIMEDOUT < ::Errno::ETIMEDOUT; include Error; end
    class ECHARSE < ::RuntimeError; include Error; end
    class EAIFAMNOSUPPORT < ::RuntimeError; include Error; end
    class EAISERVICE < ::RuntimeError; include Error; end
    class EAISOCKTYPE < ::RuntimeError; include Error; end
    class ESHUTDOWN < ::Errno::ESHUTDOWN; include Error; end
    class EEXIST < ::Errno::EEXIST; include Error; end
    class ESRCH < ::Errno::ESRCH; include Error; end
    class ENAMETOOLONG < ::Errno::ENAMETOOLONG; include Error; end
    class EPERM < ::Errno::EPERM; include Error; end
    class ELOOP < ::Errno::ELOOP; include Error; end
    class EXDEV < ::Errno::EXDEV; include Error; end
    class ENOTEMPTY < ::Errno::ENOTEMPTY; include Error; end
    class ENOSPC < ::Errno::ENOSPC; include Error; end
  end
end
