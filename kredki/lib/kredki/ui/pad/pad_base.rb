require_relative 'pad_inherited'

module Kredki
  module UI
    # Module to include in pad parents.
    module PadBase
      extend PadInherited

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

      # Search for pads matching given criteria.
      def find_pad(filter, *extra_filters, &block)
        case filter
        when Integer
          each_pad(deep: false).find{|pad| pad.pad_index == filter and extra_filters.all?{|ef| pad =~ ef } }&.then do |pad|
            block ? pad.instance_exec(pad, &block) : pad
          end
        when Range
          if filter.begin.nil?
            pad_lineage(!filter.exclude_end?).find{|pad| pad =~ filter.end and extra_filters.all?{|ef| pad =~ ef } }&.then do |pad|
              block ? pad.instance_exec(pad, &block) : pad
            end
          elsif filter.end.nil?
            case filter.begin
            when :>
              each_pad(deep: !filter.exclude_end?).filter{|pad| extra_filters.all?{|ef| pad =~ ef } }.then do |pads|
                block ? pads.each{ _1.instance_exec _1, &block } : pads
              end
            when :>>
              if filter.exclude_end?
                each_pad.filter{|pad| extra_filters.all?{|ef| pad =~ ef } }.then do |pads|
                  block ? pads.each{ _1.instance_exec _1, &block } : pads
                end
              else
                ([self].each + each_pad).filter{|pad| extra_filters.all?{|ef| pad =~ ef } }.then do |pads|
                  block ? pads.each{ _1.instance_exec _1, &block } : pads
                end
              end
            when :<<
              pad_lineage(!filter.exclude_end?).filter{|pad| extra_filters.all?{|ef| pad =~ ef } }.then do |pads|
                block ? pads.each{ _1.instance_exec _1, &block } : pads
              end
            when :not
              if filter.exclude_end?
                parent&.each_pad(deep: false, reverse: true)&.drop_while{|a| a != self }&.drop(1)
                &.filter{|pad| extra_filters.all?{|ef| pad =~ ef } }&.then do |pad|
                  block ? pad.instance_exec(pad, &block) : pad
                end
              else
                parent&.each_pad(deep: false, reverse: true)&.drop_while{|a| a != self }
                &.filter{|pad| extra_filters.all?{|ef| pad =~ ef } }&.then do |pad|
                  block ? pad.instance_exec(pad, &block) : pad
                end
              end
            when :+
              if filter.exclude_end?
                parent&.each_pad(deep: false)&.drop_while{|a| a != self }&.drop(1)
                &.filter{|pad| extra_filters.all?{|ef| pad =~ ef } }&.then do |pad|
                  block ? pad.instance_exec(pad, &block) : pad
                end
              else
                parent&.each_pad(deep: false)&.drop_while{|a| a != self }
                &.filter{|pad| extra_filters.all?{|ef| pad =~ ef } }&.then do |pad|
                  block ? pad.instance_exec(pad, &block) : pad
                end
              end
            when :~
              if filter.exclude_end?
                parent&.each_pad(deep: false)&.filter{|pad| pad != self && extra_filters.all?{|ef| pad =~ ef } }&.then do |pad|
                  block ? pad.instance_exec(pad, &block) : pad
                end
              else
                parent&.each_pad(deep: false)&.filter{|pad| extra_filters.all?{|ef| pad =~ ef } }&.then do |pad|
                  block ? pad.instance_exec(pad, &block) : pad
                end
              end
            else
              each_pad(deep: !filter.exclude_end?).filter{|pad| pad =~ filter.begin and extra_filters.all?{|ef| pad =~ ef } }.then do |pads|
                block ? pads.each{ _1.instance_exec _1, &block } : pads
              end
            end
          end
        when :>
          each_pad(deep: false).find{|pad| extra_filters.all?{|ef| pad =~ ef } }&.then do |pad|
            block ? pad.instance_exec(pad, &block) : pad
          end
        when :>>
          each_pad.find{|pad| extra_filters.all?{|ef| pad =~ ef } }&.then do |pad|
            block ? pad.instance_exec(pad, &block) : pad
          end
        when :<
          parent&.then do |pad|
            block ? pad.instance_exec(pad, &block) : pad
          end
        when :<<
          pad_lineage(false).find{|pad| extra_filters.all?{|ef| pad =~ ef } }&.then do |pad|
            block ? pad.instance_exec(pad, &block) : pad
          end
        when :not
          parent&.each_pad(deep: false, reverse: true)&.drop_while{|a| a != self }&.drop(1)
          &.find{|pad| extra_filters.all?{|ef| pad =~ ef } }&.then do |pad|
              
            block ? pad.instance_exec(pad, &block) : pad
          end
        when :+
          parent&.each_pad(deep: false)&.drop_while{|a| a != self }&.drop(1)
          &.find{|pad| extra_filters.all?{|ef| pad =~ ef } }&.then do |pad|

            block ? pad.instance_exec(pad, &block) : pad
          end
        when :~
          parent&.each_pad(deep: false)
          &.find{|pad| pad != self && extra_filters.all?{|ef| pad =~ ef } }&.then do |pad|

            block ? pad.instance_exec(pad, &block) : pad
          end
        else
          each_pad.find{|pad| pad =~ filter and extra_filters.all?{|ef| pad =~ ef } }&.then do |pad|
            block ? pad.instance_exec(pad, &block) : pad
          end
        end
      end

      # Add new job tree.
      def job &block
        RootJob.new action, block
      end

      # Add new Kredki::AfterJob.
      def after! delay = 0, &block
        job = AfterJob.new action, block, delay
        job.play
        job
      end

      # Add new Kredki::LoopJob.
      def loop! period = 0, &block
        job = LoopJob.new action, block, period
        job.play
        job
      end

      # Add new Kredki::SideJob.
      def side! &block
        job = SideJob.new action, block
        job.play
        job
      end
    end
  end
end