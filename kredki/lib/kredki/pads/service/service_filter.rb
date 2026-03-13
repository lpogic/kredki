module Kredki
  module Pads
    # Module to include in service containers.
    module ServiceFilter

      # Get self if it matches filters.
      def is *filters, **ka, &block
        return self if self =~ [*filters, ka, block]
      end

      # Find direct upper service matching filters.
      def find *filters, last: false, **ka, &block
        each(*filters, **ka, reverse: last, &block).first
      end

      # Find upper service matching filters.
      def find_upper *filters, last: false, **ka, &block
        each_upper(*filters, **ka, reverse: last, &block).first
      end

      # Find lower service matching filters.
      def find_lower *filters, last: false, **ka, &block
        each_lower(*filters, **ka, reverse: last, &block).first
      end
      
      # Get each lower service matching filters.
      def each_lower *filters, reverse: false, **ka, &block
        lower_iterator(false).then{|it| reverse ? it.reverse_each : it }.filter{|it| it =~ [*filters, ka, block] }
      end

      # Get each direct lower service matching filters.
      def each *filters, reverse: false, **ka, &block
        upper_iterator deep: false, reverse:, filter: [*filters, ka, block]
      end

      # Get each upper service matching filters.
      def each_upper *filters, reverse: false, **ka, &block
        upper_iterator deep: true, reverse:, filter: [*filters, ka, block]
      end
            
      # Get upper services iterator.
      def upper_iterator enum = nil, reverse: false, deep: true, filter: nil
        if enum
          method = reverse ? :reverse_each : :each
          case deep
          when false
            @services.send(method){|it| enum << it if it =~ filter }
          when :first
            @services.send method do |it|
              enum << it if it =~ filter 
              it.upper_iterator enum, reverse:, deep:, filter: ;
            end
          else
            @services.send(method){|it| enum << it if it =~ filter }
            @services.send(method){|it| it.upper_iterator enum, reverse:, deep:, filter: }
          end
          enum
        else
          Enumerator.new{|enum| upper_iterator enum, reverse:, deep:, filter: }
        end
      end

      # Iterate over pad descedants.
      def upper_pad_iterator enum = nil, reverse: false, deep: true
        if enum
          method = reverse ? :reverse_each : :each
          case deep
          when false
            @pads.send(method){ enum << _1 }
          when :first
            @pads.send method do
              enum << _1
              _1.upper_pad_iterator enum, reverse:, deep:;
            end
          else
            @pads.send(method){ enum << _1 }
            @pads.send(method){ _1.upper_pad_iterator enum, reverse:, deep: }
          end
          enum
        else
          Enumerator.new{|enum| upper_pad_iterator enum, reverse:, deep: }
        end
      end
    end
  end
end