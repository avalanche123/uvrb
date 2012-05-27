module UV
  class Prepare
    include Handle

    def start(&block)
      assert_block(block)
      assert_arity(1, block)

      @prepare_block = block

      check_result! UV.prepare_start(handle, callback(:on_prepare))

      self
    end

    def stop
      check_result! UV.prepare_stop(handle)

      self
    end

    private
    def on_prepare(handle, status)
      @prepare_block.call(check_result(status))
    end
  end
end