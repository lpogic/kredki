module Kredki
  module Pads
    # Module to include in service parents.
    module ServiceFilter

      # Get each ancestor matching filters.
      def each_a *filters, reverse: false, **ka, &block
        lineage(false).then{|it| reverse ? it.reverse_each : it }.filter{|it| it =~ [*filters, ka, block] }
      end

      # Get each ancestor including self matching filters.
      def each_sa *filters, reverse: false, **ka, &block
        lineage(true).then{|it| reverse ? it.reverse_each : it }.filter{|it| it =~ [*filters, ka, block] }
      end

      # Get each child matching filters.
      def each_c *filters, reverse: false, **ka, &block
        each_service deep: false, reverse:, filter: [*filters, ka, block]
      end

      # Get each descedant matching filters.
      def each_d *filters, reverse: false, **ka, &block
        each_service deep: true, reverse:, filter: [*filters, ka, block]
      end
      
      # Get self and each descedant matching filters.
      def each_sd *filters, reverse: false, **ka, &block
        filter = [*filters, ka, block]
        Enumerator.new do |it|
          it << self if self =~ filter
          each_service it, deep: true, reverse:, filter: filter
        end
      end
      
      # Find ancestor.
      def a? *filters, last: false, **ka, &block
        each_a(*filters, **ka, reverse: last, &block).first
      end

      # Find ancestor, including self.
      def sa? *filters, last: false, **ka, &block
        each_sa(*filters, **ka, reverse: last, &block).first
      end

      # Find child.
      def c? *filters, last: false, **ka, &block
        each_c(*filters, **ka, reverse: last, &block).first
      end

      # Find descedant.
      def d? *filters, last: false, **ka, &block
        each_d(*filters, **ka, reverse: last, &block).first
      end

      # Find descedant, including self.
      def sd? *filters, last: false, **ka, &block
        each_sd(*filters, **ka, reverse: last, &block).first
      end

      # Get parent if matches filters.
      def p? *filters, **ka, &block
        parent&.s? *filters, **ka, &block
      end

      # Get self if matches filters.
      def s? *filters, **ka, &block
        return self if self =~ [*filters, ka, block]
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