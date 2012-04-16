module UV
  module Handle
    def initialize(loop)
      @loop = loop
    end

    def close(&block)
      @close_block = block
      UV.close(
        handle,
        callback(:on_close)
      )
    end

    def active?
      UV.is_active(handle) > 0
    end

    def closing?
      UV.is_closing(handle) > 0
    end

    protected

    attr_reader :loop

    def handle
      @handle ||= create_handle
    end

    def handle_name
      self.class.name.split('::').last.downcase
    end

    def create_handle
      name = handle_name
      ptr = UV.malloc(UV.handle_size("uv_#{name}".to_sym))
      check_result! UV.public_send("#{name}_init", loop.pointer, ptr)
      ptr
    end

    private

    def on_close(handle)
      UV.free(handle) unless handle.null?
      @close_block.call if @close_block
      clear_callbacks
    end
  end
end