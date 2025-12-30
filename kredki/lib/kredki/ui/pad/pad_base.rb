require_relative 'pad_inherited'

module Kredki
  module UI
    # Module to include in pad parents.
    module PadBase
      extend PadInherited

      # Search for services matching given criteria.
      def find primary_filter, *filters, reverse: false, &block
        case primary_filter
        when Integer
          each_service(deep: false, reverse: reverse).find{ it =~ primary_filter and it =~ filters }&.alter &block
        when Range
          if primary_filter.end.nil?
            case primary_filter.begin
            when :>
              if primary_filter.exclude_end?
                each_service(deep: false, reverse: reverse).filter{ it =~ filters }.map{ it.alter &block }
              else
                ([self].each + each_service(deep: false, reverse: reverse)).filter{ it =~ filters }.map{ it.alter &block }
              end
            when :>>
              if primary_filter.exclude_end?
                each_service(deep: true, reverse: reverse).filter{ it =~ filters }.map{ it.alter &block }
              else
                ([self].each + each_service(deep: true, reverse: reverse)).filter{ it =~ filters }.map{ it.alter &block }
              end
            when :<
              if reverse
                lineage(!primary_filter.exclude_end?).reverse_each.filter{ it =~ filters }.map{ it.alter &block }
              else
                lineage(!primary_filter.exclude_end?).filter{ it =~ filters }.map{ it.alter &block }
              end
            when :*
              if primary_filter.exclude_end?
                parent&.each_service(deep: false, reverse: reverse)&.filter{ it != self and it =~ filters }&.map{ it.alter &block } || []
              else
                parent&.each_service(deep: false, reverse: reverse)&.filter{ it =~ filters }&.map{ it.alter &block } || []
              end
            when :+
              if primary_filter.exclude_end?
                if reverse
                  parent&.then{ it.each_service(deep: false, reverse: true).drop_while{ it != self }.drop(1).filter{ it =~ filters }.map{ it.alter &block } } || []
                else
                  parent&.then{ it.each_service(deep: false, reverse: false).take_while{ it != self }.filter{ it =~ filters }.map{ it.alter &block } } || []
                end
              else
                if reverse
                  parent&.then{ it.each_service(deep: false, reverse: true).drop_while{ it != self }.filter{ it =~ filters }.map{ it.alter &block } } || []
                else
                  parent&.then{ (it.each_service(deep: false, reverse: false).take_while{ it != self } + [self].each).filter{ it =~ filters }.map{ it.alter &block } } || []
                end
              end
            when :-
              if primary_filter.exclude_end?
                if reverse
                  parent&.then{ it.each_service(deep: false, reverse: true).take_while{ it != self }.filter{ it =~ filters }.map{ it.alter &block } } || []
                else
                  parent&.then{ it.each_service(deep: false, reverse: false).drop_while{ it != self }.drop(1).filter{ it =~ filters }.map{ it.alter &block } } || []
                end
              else
                if reverse
                  parent&.then{ (it.each_service(deep: false, reverse: true).take_while{ it != self } + [self].each).filter{ it =~ filters }.map{ it.alter &block } } || []
                else
                  parent&.then{ it.each_service(deep: false, reverse: false).drop_while{ it != self }.filter{ it =~ filters }.map{ it.alter &block } } || []
                end
              end
            else
              if primary_filter.exclude_end?
                each_service(deep: true, reverse: reverse).filter{ it =~ primary_filter.begin and it =~ filters }.map{ it.alter &block }
              else
                ([self].each + each_service(deep: true, reverse: reverse)).filter{ it =~ primary_filter.begin and it =~ filters }.map{ it.alter &block }
              end
            end
          end
        when :>
          each_service(deep: false, reverse: reverse).find{ it =~ filters }&.alter &block
        when :>>
          each_service(deep: true, reverse: reverse).find{ it =~ filters }&.alter &block
        when :<
          lineage(false).find{ it =~ filters }&.alter &block
        when :*
          parent&.then{ it.each_service(deep: false, reverse: reverse).find{ it != self and it =~ filters }&.alter &block }
        when :+
          if reverse
            parent&.then{ it.each_service(deep: false, reverse: true).drop_while{ it != self }.drop(1).find{ it =~ filters }&.alter &block }
          else
            parent&.then{ it.each_service(deep: false, reverse: false).take_while{ it != self }.find{ it =~ filters }&.alter &block }
          end
        when :-
          if reverse
            parent&.then{ it.each_service(deep: false, reverse: true).take_while{ it != self }.find{ it =~ filters }&.alter &block }
          else
            parent&.then{ it.each_service(deep: false, reverse: false).drop_while{ it != self }.drop(1).find{ it =~ filters }&.alter &block }
          end
        else
          each_service(reverse: reverse).find{ it =~ primary_filter and it =~ filters }&.alter &block
        end
      end
      
      def [](*filters, reverse: false, &block)
        filters << block if block
        find *filters, reverse: reverse
      end

      # Iterate over subservices.
      def each_service enum = nil, reverse: false, deep: true
        if enum
          method = reverse ? :reverse_each : :each
          case deep
          when false
            @services.send(method){ enum << _1 }
          when :first
            @services.send method do
              enum << _1
              _1.each_service enum, reverse:, deep:;
            end
          else
            @services.send(method){ enum << _1 }
            @services.send(method){ _1.each_service enum, reverse:, deep: }
          end
          enum
        else
          Enumerator.new{|enum| each_service enum, reverse:, deep: }
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