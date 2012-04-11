module UV
  class Prepare
    include Handle, Resource, Listener

    def start(&block)
      raise "no block given" unless block_given?
      @prepare_block = block
      check_result! UV.prepare_start(handle, callback(:on_prepare))
    end

    def stop
      check_result! UV.prepare_stop(handle)
    end

    private
    def on_prepare(handle, status)
      @prepare_block.call(check_result(status))
    end
  end
end