module UV
  class Signal
    include Assertions, Handle

    def start(signum, &block)
      assert_signal(signum)
      assert_block(block)
      assert_arity(1, block)

      @signal_block = block

      check_result! UV.signal_start(handle, callback(:on_signal), signum)

      self
    end

    def stop
      check_result! UV.signal_stop(handle)

      @signal_block = nil

      self
    end

    private

    def on_signal(handle, status)
      @signal_block.call(check_result(status))
    end
  end
end
