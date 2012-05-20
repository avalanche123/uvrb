require 'set'

module UV
  module Listener
    private
    def callbacks
      @callbacks ||= Set.new
    end

    def callback(name)
      callbacks << name
      const_name = "#{name.upcase}_#{object_id}"
      unless self.class.const_defined?(const_name)
        self.class.const_set(const_name, method(name))
      end
      self.class.const_get(const_name)
    end

    def clear_callbacks
      callbacks.each do |name|
        self.class.send(:remove_const, "#{name.upcase}_#{object_id}")
      end
      callbacks.clear
    end
  end
end