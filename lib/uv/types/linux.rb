module UV
  ruby_engine = defined?(RUBY_ENGINE) ? RUBY_ENGINE : 'ruby'

  case ruby_engine
  when 'jruby'
    typedef :uint32, :in_addr_t
    typedef :ushort, :in_port_t
  end

  class Sockaddr < FFI::Struct
    layout :sa_family, :sa_family_t,
           :sa_data, [:char, 14]
  end

  class InAddr < FFI::Struct
    layout :s_addr, :in_addr_t
  end

  class SockaddrIn < FFI::Struct
    layout :sin_family, :sa_family_t,
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
    layout :sin6_family, :sa_family_t,
           :sin6_port, :in_port_t,
           :sin6_flowinfo, :uint32,
           :sin6_addr, In6Addr,
           :sin6_scope_id, :uint32
  end
end
