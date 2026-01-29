module Kredki
  module Pads
    # Module to include in service parents.
    module ServiceFilter

      # Get each descedant matching filters.
      def ed *filters, reverse: false, **na, &block
        each_service deep: true, reverse:, filter: [*filters, na, block]
      end

      # Get each child matching filters.
      def ec *filters, reverse: false, **na, &block
        each_service deep: false, reverse:, filter: [*filters, na, block]
      end

      # Get each ancestor matching filters.
      def ea *filters, with_self: false, reverse: false, **na, &block
        lineage(with_self).then{|it| reverse ? it.reverse_each : it }.filter{|it| it =~ [*filters, na, block] }
      end

      # Find descedant.
      def fd *filters, last: false, **na, &block
        ed(*filters, **na, reverse: last, &block).first
      end

      # Find child.
      def fc *filters, last: false, **na, &block
        ec(*filters, **na, reverse: last, &block).first
      end

      # Find ancestor.
      def fa *filters, with_self: false, last: false, **na, &block
        ea(*filters, **na, with_self:, reverse: last, &block).first
      end

      # Get parent if matches filters.
      def pa *filters, **na, &block
        parent&.is *filters, **na, &block
      end

      # Get self if matches filters.
      def is *filters, **na, &block
        return self if self =~ [*filters, na, block]
      end

      # Get self if doesn't match filters.
      def isnt *filters, **na, &block
        return self if [*filters, *na.map{|k, v| {k => v} }, block].none?{|it| self =~ it }
      end
      
      # Iterate over service descedants.
      def each_service enum = nil, reverse: false, deep: true, filter: nil
        if enum
          method = reverse ? :reverse_each : :each
          case deep
          when false
            @services.send(method){|it| enum << it if it =~ filter }
          when :first
            @services.send method do |it|
              enum << it if it =~ filter 
              it.each_service enum, reverse:, deep:, filter: ;
            end
          else
            @services.send(method){|it| enum << it if it =~ filter }
            @services.send(method){|it| it.each_service enum, reverse:, deep:, filter: }
          end
          enum
        else
          Enumerator.new{|enum| each_service enum, reverse:, deep:, filter: }
        end
      end

      # Iterate over pad descedants.
      def each_pad enum = nil, reverse: false, deep: true
        if enum
          method = reverse ? :reverse_each : :each
          case deep
          when false
            @pads.send(method){ enum << _1 }
          when :first
            @pads.send method do
              enum << _1
              _1.each_pad enum, reverse:, deep:;
            end
          else
            @pads.send(method){ enum << _1 }
            @pads.send(method){ _1.each_pad enum, reverse:, deep: }
          end
          enum
        else
          Enumerator.new{|enum| each_pad enum, reverse:, deep: }
        end
      end
    end
  end
end