module UV
  class FSEvent
    include Handle

    EVENTS = {1 => :rename, 2 => :change}.freeze

    def initialize(loop, fs_event_ptr, &block)
      @fs_event_block = block

      super(loop, fs_event_ptr)
    end

    private

    def on_fs_event(handle, filename, events, status)
      @fs_event_block.call(check_result(status), filename, EVENTS[events])
    end

    public :callback
  end
end