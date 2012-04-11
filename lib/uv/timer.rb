module UV
  class Timer
    include Handle, Resource, Listener

    def start(timeout, repeat, &block)
      raise "no block given" unless block_given?
      @timer_block = block
      check_result! UV.timer_start(
        handle,
        callback(:on_timer),
        Integer(timeout),
        Integer(repeat)
      )
    end

    def stop
      check_result! UV.timer_stop(handle)
    end

    def again
      check_result! UV.timer_again(handle)
    end

    def repeat=(repeat)
      check_result! UV.timer_set_repeat(handle, Integer(repeat))
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