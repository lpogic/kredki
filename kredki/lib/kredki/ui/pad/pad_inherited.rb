module Kredki
  module UI
    module PadInherited
      def self.extended cl
        cl.define_singleton_method :inherited do |cl1|
          cl1.extend PadInherited
        end
      end

      def param_service name
        class_eval <<~XX
          def #{name}! ...
            #{name}.alter(...)
          end
        XX
      end

      def def! name, klass = nil, *def_a, **def_na, &def_b
        case klass
        when Class
          define_method name do |*a, **na, &b|
            new(klass, name, *def_a, **def_na, **na, &def_b).alter *a, &b
          end
        when true
          define_method name do |*a, **na, &b|
            a = [name, *def_a, *a]
            na = {**def_na, **na}
            instance_exec(a, na, b, self, &def_b).alter *a, **na, &b
          end
        else
          define_method name do |*a, **na, &b|
            a = [name, *def_a, *a]
            na = {**def_na, **na}
            instance_exec a, na, b, self, &def_b
          end
        end
      end
    end#PadInherited
  end#UI
end#Kredki