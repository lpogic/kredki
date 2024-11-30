module Kredki
  module UI
    module PadInherited
      def self.extended cl
        cl.define_singleton_method :inherited do |cl1|
          cl1.extend PadInherited
        end
      end

      def def_forward filter, *methods
        methods.each do |method|
          define_method method do |*a, **na, &b|
            self[filter].send method, *a, **na, &b
          end
        end
      end

      def defw_resp *methods
        methods.each do |method|
          def_forward proc{ _1.respond_to? method }, method
        end
      end

      def def_pad name, klass = nil, &block
        if block
          define_method name do |*a, **na, &b|
            pad = instance_exec a, na, b, self, &block
            pad.alter! name, *a, **na, &b if klass
            pad
          end
        else
          define_method name do |*a, **na, &b|
            new_pad klass, name, *a, **na, &b
          end
        end
      end
    end
  end
end