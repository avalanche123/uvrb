module UV
  module Handle
    include Assertions, Resource, Listener

    def initialize(loop, pointer)
      @loop, @pointer = loop, pointer
    end

    # Public: Increment internal ref counter for the handle on the loop. Useful for
    # extending the loop with custom watchers that need to make loop not stop
    # 
    # Returns nothing
    def ref
      UV.ref(@pointer)
    end

    # Public: Decrement internal ref counter for the handle on the loop, useful to stop
    # loop even when there are outstanding open handles
    # 
    # Returns nothing
    def unref
      UV.unref(@pointer)
    end

    def close(&block)
      assert_block(block)
      assert_arity(0, block)

      @close_block = block

      UV.close(
        @pointer,
        callback(:on_close)
      )
    end

    def active?
      UV.is_active(@pointer) > 0
    end

    def closing?
      UV.is_closing(@pointer) > 0
    end

    protected

    def loop; @loop; end
    def handle; @pointer; end

    private

    def handle_name
      self.class.name.split('::').last.downcase.to_sym
    end

    def on_close(pointer)
      UV.free(pointer)
      clear_callbacks
      @close_block.call
    end
  end
end