require 'set'

module UV
  module Listener
    @@callbacks = Hash.new { |hash, object_id| hash[object_id] = Hash.new }

    class << self
      def define_callback(object_id, name, callback)
        @@callbacks[object_id][name] ||= callback
      end

      def undefine_callbacks(object_id)
        @@callbacks.delete(object_id)
        nil
      end
    end

    private

    def callback(name)
      Listener.define_callback(object_id, name, method(name))
    end

    def clear_callbacks
      Listener.undefine_callbacks(object_id)
    end
  end
end