module Kredki
  module UI
    module PadBase

      def [](filter, reverse: false, deep_first: false, &block)
        case filter
        when Integer
          if block
            pads.find{ _1.pad_index == filter }&.then{ _1.instance_exec _1, &block }
          else
            pads.find{ _1.pad_index == filter }
          end
        when Range
          if filter.begin.nil?
            lineage(false).find{ _1 =~ filter.end }&.then do |pad|
              block ? pad.instance_exec(pad, &block) : pad
            end
          elsif filter.end.nil?
            each_pad(reverse:, deep_first:).filter{ _1 =~ filter.begin }.then do |pads|
              block ? pads.each{ _1.instance_exec _1, &block } : pads
            end
          end
        else
          each_pad(reverse:, deep_first:).find{ _1 =~ filter }&.then do |pad|
            block ? pad.instance_exec(pad, &block) : pad
          end
        end
      end

      def []=(filter, value)
        self[filter]{ _1 << value }
        value
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

      def self.def_pad name, klass = nil, *def_a, **def_na, &def_b
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

      def def_forward filter, *methods
        methods.each do |method|
          define_singleton_method method do |*a, **na, &b|
            self[filter].send method, *a, **na, &b
          end
        end
      end

      def defw_resp *methods
        methods.each do |method|
          def_forward proc{ _1.respond_to? method }, method
        end
      end

      def orphan! &block
        orphan = Orphan.new
        orphan.patron = self
        block ? orphan.instance_exec(&block) : orphan
      end
    end

    class Orphan
      include PadBase
      attr_accessor :patron
      
      def new_pad klass = Pad, *a, **na, &b
        pad = klass.new
        pad.sketch_base
        pad.alter(*a, **patron&._pad_defaults(pad), **na, &b).alter_commit
        pad
      end
    end
  end
end