module Kredki
  module UI
    module PadInherited
      def self.extended cl
        cl.define_singleton_method :inherited do |cl1|
          cl1.extend PadInherited
        end
      end

      def feature_service name
        class_eval <<~xx
          def #{name}! ...
            #{name}.alter(...)
          end
        xx

        class_eval <<~xx
          def #{name}= value
            #{name}! *Util.cover(value)
          end
        xx
      end

      def define name, klass = nil, &block
        case klass
        when Class
          class_eval <<~xx
            def #{name} ...
              new(#{klass}, :#{name}, ...)
            end
          xx
        when nil
          if block.parameters.empty?
            define_method name do |*a, **na, &b|
              instance_exec(&block).alter *a, **na, &b
            end
          else
            define_method name do |*a, **na, &b|
              instance_exec(*a, **na, &block).alter &b
            end
          end
        else raise_ia klass
        end
      end

    end#PadInherited
  end#UI
end#Kredki