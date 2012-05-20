module UV
  module Assertions
    def assert_block(proc, msg = "no block given")
      raise ArgumentError, msg, caller if proc.nil?
    end

    def assert_arity(expected, proc, msg = nil)
      actual = proc.arity
      arg  = expected == 1 ? "argument" : "arguments"
      msg  ||= "block must accept #{expected} #{arg}, but accepts #{actual}"
      raise ArgumentError, msg, caller if expected != actual
    end

    def assert_type(type, actual, msg = nil)
      msg ||= "value #{actual.inspect} is not a valid #{type}"
      raise ArgumentError, msg, caller unless actual.kind_of?(type)
    end

    def assert_boolean(actual, msg = nil)
      msg ||= "value #{actual.inspect} is not a valid Boolean"
      raise ArgumentError, msg, caller unless actual.kind_of?(TrueClass) || actual.kind_of?(FalseClass)
    end
  end
end