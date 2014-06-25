require 'set'

module UV
  module Listener
    @@methods = Hash.new { |hash, object_id| hash[object_id] = Hash.new }
    @@procs   = Hash.new { |hash, object_id| hash[object_id] = Hash.new }

    class << self
      def define_callback(object_id, name, callback)
        @@methods[object_id][name] ||= callback
      end

      def undefine_callbacks(object_id)
        @@methods.delete(object_id)
        @@procs.delete(object_id)
        nil
      end

      def callback(object_id, &block)
        @@procs[object_id][block.object_id] = Proc.new do |*args|
          @@procs[object_id].delete(block.object_id)
          block.call(*args)
        end
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