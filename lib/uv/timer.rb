module UV
  class Timer
    include Assertions, Handle

    def start(timeout, repeat, &block)
      assert_block(block)
      assert_arity(1, block)
      assert_type(Integer, timeout, "timeout must be an Integer")
      assert_type(Integer, repeat, "repeat must be an Integer")

      @timer_block = block

      check_result! UV.timer_start(handle, callback(:on_timer), timeout, repeat)

      self
    end

    def stop
      check_result! UV.timer_stop(handle)

      self
    end

    def again
      check_result! UV.timer_again(handle)

      self
    end

    def repeat=(repeat)
      assert_type(Integer, repeat, "repeat must be an Integer")

      check_result! UV.timer_set_repeat(handle, repeat)

      self
    end

    def repeat
      UV.timer_get_repeat(handle)
    end

    private

    def on_timer(handle, status)
      @timer_block.call(check_result(status))
    end
  end
end