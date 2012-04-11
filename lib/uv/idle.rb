module UV
  class Idle
    include Handle, Resource, Listener

    def start(&block)
      raise "no block given" unless block_given?
      @idle_block = block
      check_result! UV.idle_start(handle, callback(:on_idle))
    end

    def stop
      check_result! UV.idle_stop(handle)
    end

    private
    def on_idle(handle, status)
      @idle_block.call(check_result(status))
    end
  end
end