module UV
  module Resource
    def check_result(rc)
      @loop.lookup_error(rc) unless rc == 0 || rc.nil?
    end

    def check_result!(rc)
      e = check_result(rc)
      raise e if e
    end

    def to_ptr
      @pointer
    end

    protected

    attr_reader :loop
  end
end