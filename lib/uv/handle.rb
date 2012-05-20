module UV
  module Handle
    include Assertions

    def initialize(loop, pointer)
      @loop, @pointer = loop, pointer
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