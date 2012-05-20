module UV
  class Check
    include Handle, Resource, Listener

    def start(&block)
      assert_block(block)
      assert_arity(1, block)

      @check_block = block

      check_result! UV.check_start(handle, callback(:on_check))
    end

    def stop
      check_result! UV.check_stop(handle)
    end

    private
    def on_check(handle, status)
      @check_block.call(check_result(status))
    end
  end
end