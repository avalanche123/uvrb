module UV
  class Async
    include Handle, Resource, Listener

    def initialize(loop, async_ptr, &block)
      super(loop, async_ptr)
      raise ArgumentError, "no block given", caller unless block_given?
      @async_block = block
    end

    def send
      check_result UV.async_send(handle)
    end

    private
    def on_async(handle, status)
      @async_block.call(check_result(status))
    end
  end
end