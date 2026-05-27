module Kredki
  module Pads
    # Module to include in service containers.
    module ServiceFilter

      # Get self if it matches filters.
      def is *filters, **ka, &block
        return self if self =~ [*filters, ka, block]
      end

      # Find direct upper service matching filters.
      def direct_upper *filters, last: false, **ka, &block
        each_direct_upper(*filters, **ka, reverse: last, &block).first
      end

      # Find upper service matching filters.
      def upper *filters, last: false, **ka, &block
        each_upper(*filters, **ka, reverse: last, &block).first
      end

      # See #upper.
      alias_method :[], :upper

      # Find lower service matching filters.
      def lower *filters, last: false, **ka, &block
        each_lower(*filters, **ka, reverse: last, &block).first
      end

      # Get each direct upper service matching filters.
      def each_direct_upper *filters, reverse: false, **ka, &block
        upper_iterator deep: false, reverse:, direct_call: true, filter: [*filters, ka, block]
      end
      
      # Get each lower service matching filters.
      def each_lower *filters, reverse: false, **ka, &block
        lower_iterator(false).then{|it| reverse ? it.reverse_each : it }.filter{|it| it =~ [*filters, ka, block] }
      end

      # Get each upper service matching filters.
      def each_upper *filters, reverse: false, **ka, &block
        upper_iterator deep: true, reverse:, direct_call: true, filter: [*filters, ka, block]
      end
            
      # Get upper services iterator.
      def upper_iterator enum = nil, reverse: false, deep: true, filter: nil, direct_call: false
        if enum
          case deep
          when false
            each_service(reverse, direct_call){|it| enum << it if it =~ filter }
          when :first
            each_service reverse, direct_call do |it|
              enum << it if it =~ filter 
              it.upper_iterator enum, reverse:, deep:, filter: ;
            end
          else
            each_service(reverse, direct_call){|it| enum << it if it =~ filter }
            each_service(reverse, direct_call){|it| it.upper_iterator enum, reverse:, deep:, filter: }
          end
          enum
        else
          Enumerator.new{|enum| upper_iterator enum, reverse:, deep:, filter: }
        end
      end

      # Iterate over pad descedants.
      def upper_pad_iterator enum = nil, reverse: false, deep: true, direct_call: false
        if enum
          case deep
          when false
            each_pad(reverse, direct_call){ enum << _1 }
          when :first
            each_pad reverse, direct_call do
              enum << _1
              _1.upper_pad_iterator enum, reverse:, deep:;
            end
          else
            each_pad(reverse, direct_call){ enum << _1 }
            each_pad(reverse, direct_call){ _1.upper_pad_iterator enum, reverse:, deep: }
          end
          enum
        else
          Enumerator.new{|enum| upper_pad_iterator enum, reverse:, deep: }
        end
      end
    end
  end
end