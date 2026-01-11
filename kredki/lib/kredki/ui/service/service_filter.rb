module Kredki
  module UI
    # Module to include in service parents.
    module ServiceFilter

      # Get filtered descedants.
      def each_fd *filters, reverse: false, &block
        each_service deep: true, reverse:, filter: [*filters, block]
      end

      # Get filtered children.
      def each_fc *filters, reverse: false, &block
        each_service deep: false, reverse:, filter: [*filters, block]
      end

      # Get filtered ancestors.
      def each_fa *filters, with_self: false, reverse: false, &block
        lineage(with_self).then{ reverse ? it.reverse_each : it }.filter{ it =~ filters and it =~ block }
      end

      def each_sb *filters, reverse: false, &block
        found = false
        detect = proc do
          if found
            !reverse
          else
            found = it == self
            reverse
          end
        end
        parent&.each_service(deep: false, reverse: !reverse, filter: [detect, *filters, block]) || []
      end

      def each_sn *filters, reverse: false, &block
        found = false
        detect = proc do
          if found
            !reverse
          else
            found = it == self
            reverse
          end
        end
        parent&.each_service(deep: false, reverse: reverse, filter: [detect, *filters, block]) || []
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

      def sb *filters, &block
        found = false
        detect = proc do
          if found
            !reverse
          else
            found = it == self
            reverse
          end
        end
        parent&.each_service(deep: false, filter: detect)&.first&.is *filters, &block
      end

      def sn *filters, &block
        found = false
        detect = proc do
          if found
            !reverse
          else
            found = it == self
            reverse
          end
        end
        parent&.each_service(deep: false, filter: detect)&.first&.is *filters, &block
      end

      # Get whether parent match filters.
      def pa *filters, &block
        parent&.is *filters, &block
      end

      # Get whether match all filters.
      def is *filters, &block
        self =~ filters && self =~ block ? self : false
      end

      # Get whether not match all filter.
      def isnt *filters, &block
        filters.all?{ self !~ filters } && (!block || self !~ block ? self : false)
      end
      
      # Iterate over subservices.
      def each_service enum = nil, reverse: false, deep: true, filter: nil
        if enum
          method = reverse ? :reverse_each : :each
          case deep
          when false
            @services.send(method){ enum << it if it =~ filter }
          when :first
            @services.send method do
              enum << it if it =~ filter 
              it.each_service enum, reverse:, deep:, filter: ;
            end
          else
            @services.send(method){ enum << it if it =~ filter }
            @services.send(method){ it.each_service enum, reverse:, deep:, filter: }
          end
          enum
        else
          Enumerator.new{|enum| each_service enum, reverse:, deep:, filter: }
        end
      end

      # Iterate over subpads.
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

      # Add new job tree.
      def job &block
        RootJob.new block
      end

      # Add new Kredki::AfterJob.
      def after! delay = 0, &block
        job = AfterJob.new block, delay
        job.run window
        job
      end

      # Add new Kredki::LoopJob.
      def loop! period = 0, &block
        job = LoopJob.new block, period
        job.run window
        job
      end

      # Add new Kredki::SideJob.
      def side! &block
        job = SideJob.new block
        job.run window
        job
      end
    end
  end
end