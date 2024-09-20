module Kredki
  module UI
    module PadBase

      def [](filter, &block)
        if block
          each_pad.filter{ _1 =~ filter }.map{ block.call _1 }
        else
          each_pad.find{ _1 =~ filter }
        end
      end

      def each_pad enum = nil
        if enum
          @pads.each{ enum << _1 }
          @pads.each{ _1.each_pad enum }
          enum
        else
          Enumerator.new do |enum|
            each_pad enum
          end
        end
      end
      

      def def_pad name, klass = nil, &block
        if block
          PadBase.define_method name do |*a, **na, &b|
            instance_exec(klass, &block).alter *a, **na, &b
          end
        else
          PadBase.define_method name do |*a, **na, &b|
            new_pad(klass).alter *a, **na, &b
          end
        end
      end

      def self.def_pad name, klass = nil, &block
        if block
          define_method name do |*a, **na, &b|
            instance_exec(klass, &block).alter *a, **na, &b
          end
        else
          define_method name do |*a, **na, &b|
            new_pad(klass).alter *a, **na, &b
          end
        end
      end
    end
  end
end