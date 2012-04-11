module UV
  module Resource
    def self.included(base)
      base.extend(self)
    end

    def check_result(rc)
      @loop.last_error if rc == -1
    end

    def check_result!(rc)
      e = check_result(rc)
      raise e if e
    end

    protected

    attr_reader :loop
  end
end