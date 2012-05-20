module UV
  module Handle
    def initialize(loop, pointer)
      @loop, @pointer = loop, pointer
    end

    def close(&block)
      raise ArgumentError, "no block given", caller unless block_given?
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