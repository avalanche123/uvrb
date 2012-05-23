module UV
  class Async
    include Handle

    # :stopdoc:
    def initialize(loop, async_ptr, &block) # :yields: error
      assert_block(block)
      assert_arity(1, block)

      @async_block = block

      super(loop, async_ptr)
    end
    # :startdoc:

    def call
      check_result UV.async_send(handle)
    end

    private
    def on_async(handle, status)
      @async_block.call(check_result(status))
    end

    public :callback
  end
end