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
      
      # Find lower service matching filters.
      def lower *filters, last: false, **ka, &block
        each_lower(*filters, **ka, reverse: last, &block).first
      end
      
      # Get each lower service matching filters.
      def each_lower *filters, reverse: false, **ka, &block
        lower_enumerator(false).then{|it| reverse ? it.reverse_each : it }.filter{|it| it =~ [*filters, ka, block] }
      end

      # Get each upper service matching filters.
      def each_upper *filters, reverse: false, **ka, &block
        upper_enumerator deep: true, reverse:, direct_call: true, filter: [*filters, ka, block]
      end

      # Get each direct upper service matching filters.
      def each_direct_upper *filters, reverse: false, **ka, &block
        upper_enumerator deep: false, reverse:, direct_call: true, filter: [*filters, ka, block]
      end

      def find trace, reverse: false, deep_first: nil
        service = each(trace, reverse: reverse, deep_first: deep_first).first
        service ? block_given? ? yield(service) : service : nil
      end

      def each trace, reverse: false, deep_first: nil
        deep = if deep_first.nil?
          reverse ? :first : true
        elsif deep_first
          :first
        else
          true
        end
        
        enumerator = case trace
        when Trace
          trace = trace.each.to_a
          upper_enumerator reverse: reverse, deep: deep, filter: proc{|it| trace_match it, trace }
        else
          upper_enumerator reverse: reverse, deep: deep, filter: trace
        end
        block_given? ? enumerator.each{|it| yield it } : enumerator
      end

      def trace_match subject, trace
        i = trace.size - 1
        fail_on_mismatch = true
        subject.lower_enumerator(true).each do |it|
          if i < 0
            return !fail_on_mismatch || it == self
          elsif it =~ trace[i].data
            i -= 1
            fail_on_mismatch = false
            if trace[i].is_a? NegativeTrace
              i -= 1
              fail_on_mismatch = true
            end
          elsif fail_on_mismatch
            return false
          end
        end
        false
      end

      alias_method :[], :find
            
      # Get upper services iterator.
      def upper_enumerator enum = nil, reverse: false, deep: true, filter: nil, direct_call: false
        if enum
          case deep
          when false
            each_service(reverse, direct_call){|it| enum << it if it =~ filter }
          when :first
            each_service reverse, direct_call do |it|
              it.upper_enumerator enum, reverse:, deep:, filter: ;
              enum << it if it =~ filter 
            end
          else
            each_service(reverse, direct_call){|it| enum << it if it =~ filter }
            each_service(reverse, direct_call){|it| it.upper_enumerator enum, reverse:, deep:, filter: }
          end
          enum
        else
          Enumerator.new{|enum| upper_enumerator enum, reverse:, deep:, filter: }
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