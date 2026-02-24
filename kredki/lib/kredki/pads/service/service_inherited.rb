module Kredki
  module Pads
    # Module extended in Kredki::Pads::Service and all inherited classes.
    module ServiceInherited
      def self.extended cl
        cl.define_singleton_method :inherited do |cl1|
          cl1.extend ServiceInherited
        end
      end

      # Define common Pads method.
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
            define_method name do |*a, **ka, &b|
              instance_exec(&block).alter *a, **ka, &b
            end
          else
            define_method name do |*a, **ka, &b|
              instance_exec(*a, **ka, &block).alter &b
            end
          end
        else raise_ia klass
        end
      end

    end#ServiceInherited
  end#Pads
end#Kredki