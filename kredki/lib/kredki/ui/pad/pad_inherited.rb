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
            target = self[filter]
            raise "Cant find target for ::#{method}" unless target
            target.send method, *a, **na, &b
          end
        end
      end

      def defw_resp *methods
        methods.each do |method|
          def_forward proc{ _1.respond_to? method }, method
        end
      end

      def defw_param *params, get: true
        params.each do |param|
          defw_resp "#{param}!".to_sym, "#{param}=".to_sym
          defw_resp param if get
        end
      end

      def def_pad name, klass = nil, *def_a, **def_na, &def_b
        case klass
        when Class
          define_method name do |*a, **na, &b|
            pad = new_pad klass, name, *def_a, **def_na, &def_b
            pad.alter *a, **na, &b
          end
        when true
          define_method name do |*a, **na, &b|
            a = [name, *def_a, *a]
            na = {**def_na, **na}
            pad = instance_exec a, na, b, self, &def_b
            pad.alter *a, **na, &b
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