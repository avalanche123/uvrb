module UV
  class Work
    include Resource, Listener

    def initialize(loop, work, callback = nil)
      @loop, @work, @callback = loop, work, callback
      @complete = false

      @pointer = UV.create_request(:uv_work)
      begin
        check_result! UV.queue_work(@loop, @pointer, callback(:on_work), callback(:on_complete))
      rescue StandardError => e
        UV.free(@pointer)
        @complete = true
        raise e
      end
    end

    def cancel
      if not @complete
        check_result! UV.cancel(@pointer)
        @complete = true
      end
    end

    def completed?
      return @complete
    end

    private
    def on_complete(req)
      @complete = true
      UV.free(req)
      @callback.call unless @callback.nil?
    end

    def on_work(req)
      @work.call
    end
  end
end