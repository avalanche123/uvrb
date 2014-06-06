module UV
  class Idle
    include Handle

    def start(&block)
      assert_block(block)
      assert_arity(1, block)

      @idle_block = block

      check_result! UV.idle_start(handle, callback(:on_idle))

      self
    end

    def stop
      check_result! UV.idle_stop(handle)

      @idle_block = nil

      self
    end

    private

    def on_idle(handle, status)
      @idle_block.call(check_result(status))
    end
  end
end