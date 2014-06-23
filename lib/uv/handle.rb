module UV
  module Handle
    include Assertions, Resource, Listener

    class << self
      def close(object_id, handle)
        Proc.new do
          Listener.undefine_callbacks(object_id)
          UV.close(handle, UV.method(:free)) unless handle.null?
        end
      end
    end

    def initialize(loop, pointer)
      @loop, @pointer = loop, pointer

      ObjectSpace.define_finalizer(self, Handle.close(object_id, @pointer))
    end

    # Public: Increment internal ref counter for the handle on the loop. Useful for
    # extending the loop with custom watchers that need to make loop not stop
    # 
    # Returns self
    def ref
      UV.ref(@pointer)

      self
    end

    # Public: Decrement internal ref counter for the handle on the loop, useful to stop
    # loop even when there are outstanding open handles
    # 
    # Returns self
    def unref
      UV.unref(@pointer)

      self
    end

    def close(&block)
      ObjectSpace.undefine_finalizer(self)

      return if @pointer.nil?

      if block
        assert_block(block)
        assert_arity(0, block)

        @close_block = block
      end

      UV.close(@pointer, callback(:on_close))

      self
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

      @close_block && @close_block.call
      @close_block = nil

      @pointer = nil
    end
  end
end