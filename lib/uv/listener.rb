require 'set'

module UV
  module Listener
    module ClassMethods
      def const_unset(name)
        remove_const(name)
      end
    end

    def self.included(base)
      base.extend(ClassMethods)
    end

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
        self.class.const_unset("#{name.upcase}_#{object_id}")
      end
      callbacks.clear
    end
  end
end