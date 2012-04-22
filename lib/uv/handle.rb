module UV
  module Handle
    def initialize(loop)
      @loop = loop
      @pointer = create_handle
    end

    def close(&block)
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

    attr_reader :loop

    def handle_name
      self.class.name.split('::').last.downcase
    end

    def create_handle
      name = handle_name
      ptr = UV.malloc(UV.handle_size("uv_#{name}".to_sym))
      check_result! UV.public_send("#{name}_init", loop.to_ptr, ptr)
      ptr
    end

    private

    def on_close(pointer)
      UV.free(pointer)
      clear_callbacks
      @close_block.call if @close_block
    end
  end
end