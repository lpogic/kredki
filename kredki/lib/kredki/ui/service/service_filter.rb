module Kredki
  module UI
    # Module to include in service parents.
    module ServiceFilter

      # Get descedants matching filters.
      def each_fd *filters, reverse: false, &block
        each_service deep: true, reverse:, filter: [*filters, block]
      end

      # Get children matching filters.
      def each_fc *filters, reverse: false, &block
        each_service deep: false, reverse:, filter: [*filters, block]
      end

      # Get ancestors matching filters.
      def each_fa *filters, with_self: false, reverse: false, &block
        lineage(with_self).then{|it| reverse ? it.reverse_each : it }.filter{|it| it =~ filters and it =~ block }
      end

      # Find descedant.
      def fd *filters, last: false, &block
        each_fd(*filters, reverse: last, &block).first
      end

      # Find child.
      def fc *filters, last: false, &block
        each_fc(*filters, reverse: last, &block).first
      end

      # Find ancestor.
      def fa *filters, with_self: false, last: false, &block
        each_fa(*filters, with_self:, reverse: last, &block).first
      end

      # Get whether parent match filters.
      def pa *filters, &block
        parent&.is *filters, &block
      end

      # Get whether match all filters.
      def is *filters, &block
        self =~ filters && self =~ block ? self : false
      end

      # Get whether not match all filters.
      def isnt *filters, &block
        filters.all?{ self !~ filters } && (!block || self !~ block ? self : false)
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