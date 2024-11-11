module Kredki
  module UI
    module PadBase

      def [](filter, &block)
        case filter
        when Integer
          if block
            pads.find{ _1.pad_index == filter }&.then{ _1.instance_exec _1, &block }
          else
            pads.find{ _1.pad_index == filter }
          end
        else
          if block
            each_pad.filter{ _1 =~ filter }.map{ _1.instance_exec _1, &block }
          else
            each_pad.find{ _1 =~ filter }
          end
        end
      end

      def each_pad enum = nil, reverse: false, deep_first: false
        if enum
          method = reverse ? :reverse_each : :each
          if deep_first
            @pads.send method do
              enum << _1
              _1.each_pad enum, reverse:, deep_first:;
            end
          else
            @pads.send(method){ enum << _1 }
            @pads.send(method){ _1.each_pad enum, reverse:, deep_first: }
          end
          enum
        else
          Enumerator.new{|enum| each_pad enum, reverse:, deep_first: }
        end
      end
      

      def def_pad name, klass = nil, &block
        if block
          PadBase.define_method name do |*a, **na, &b|
            pad = instance_exec a, na, b, self, &block
            pad.alter! name, *a, **na, &b if klass
            pad
          end
        else
          PadBase.define_method name do |*a, **na, &b|
            new_pad klass, name, *a, **na, &b
          end
        end
      end

      def self.def_pad name, klass = nil, &block
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