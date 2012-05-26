module UV
  # blksize_t, in_addr_t is not yet part of types.conf on linux
  typedef :long, :blksize_t
  typedef :uint32, :in_addr_t
  typedef :ushort, :in_port_t
end