module UV
  module Assertions
    def assert_block(proc, msg = "no block given")
      raise ArgumentError, msg, caller if proc.nil?
    end

    def assert_arity(expected, proc, msg = nil)
      actual = proc.arity
      if expected != actual
        arg  = expected == 1 ? "argument" : "arguments"
        msg  ||= "block must accept #{expected} #{arg}, but accepts #{actual}"
        raise ArgumentError, msg, caller
      end
    end

    def assert_type(type, actual, msg = nil)
      if not actual.kind_of?(type)
        msg ||= "value #{actual.inspect} is not a valid #{type}"
        raise ArgumentError, msg, caller
      end
    end

    def assert_boolean(actual, msg = nil)
      if not (actual.kind_of?(TrueClass) || actual.kind_of?(FalseClass))
        msg ||= "value #{actual.inspect} is not a valid Boolean"
        raise ArgumentError, msg, caller
      end
    end

    def assert_signal(signo, msg = nil)
      if not ::Signal.list.values.include?(signo)
        msg ||= "undefined signal number: #{signo}"
        raise ArgumentError, msg, caller
      end
    end
  end
end