module Kredki
  module UI
    module PadBase

      def [](filter, *extra_filters, &block)
        case filter
        when Integer
          each_service(deep: false).find{|pad| pad.pad_index == filter and extra_filters.all?{|ef| pad =~ ef } }&.then do |pad|
            block ? pad.instance_exec(pad, &block) : pad
          end
        when Range
          if filter.begin.nil?
            lineage(!filter.exclude_end?).find{|pad| pad =~ filter.end and extra_filters.all?{|ef| pad =~ ef } }&.then do |pad|
              block ? pad.instance_exec(pad, &block) : pad
            end
          elsif filter.end.nil?
            case filter.begin
            when :>
              each_service(deep: !filter.exclude_end?).filter{|pad| extra_filters.all?{|ef| pad =~ ef } }.then do |pads|
                block ? pads.each{ _1.instance_exec _1, &block } : pads
              end
            when :>>
              if filter.exclude_end?
                each_service.filter{|pad| extra_filters.all?{|ef| pad =~ ef } }.then do |pads|
                  block ? pads.each{ _1.instance_exec _1, &block } : pads
                end
              else
                ([self].each + each_service).filter{|pad| extra_filters.all?{|ef| pad =~ ef } }.then do |pads|
                  block ? pads.each{ _1.instance_exec _1, &block } : pads
                end
              end
            when :<<
              lineage(!filter.exclude_end?).filter{|pad| extra_filters.all?{|ef| pad =~ ef } }.then do |pads|
                block ? pads.each{ _1.instance_exec _1, &block } : pads
              end
            when :-
              if filter.exclude_end?
                parent&.each_service(deep: false, reverse: true)&.drop_while{|a| a != self }&.drop(1)
                &.filter{|pad| extra_filters.all?{|ef| pad =~ ef } }&.then do |pad|
                  block ? pad.instance_exec(pad, &block) : pad
                end
              else
                parent&.each_service(deep: false, reverse: true)&.drop_while{|a| a != self }
                &.filter{|pad| extra_filters.all?{|ef| pad =~ ef } }&.then do |pad|
                  block ? pad.instance_exec(pad, &block) : pad
                end
              end
            when :+
              if filter.exclude_end?
                parent&.each_service(deep: false)&.drop_while{|a| a != self }&.drop(1)
                &.filter{|pad| extra_filters.all?{|ef| pad =~ ef } }&.then do |pad|
                  block ? pad.instance_exec(pad, &block) : pad
                end
              else
                parent&.each_service(deep: false)&.drop_while{|a| a != self }
                &.filter{|pad| extra_filters.all?{|ef| pad =~ ef } }&.then do |pad|
                  block ? pad.instance_exec(pad, &block) : pad
                end
              end
            when :~
              if filter.exclude_end?
                parent&.each_service(deep: false)&.filter{|pad| pad != self && extra_filters.all?{|ef| pad =~ ef } }&.then do |pad|
                  block ? pad.instance_exec(pad, &block) : pad
                end
              else
                parent&.each_service(deep: false)&.filter{|pad| extra_filters.all?{|ef| pad =~ ef } }&.then do |pad|
                  block ? pad.instance_exec(pad, &block) : pad
                end
              end
            else
              each_service(deep: !filter.exclude_end?).filter{|pad| pad =~ filter.begin and extra_filters.all?{|ef| pad =~ ef } }.then do |pads|
                block ? pads.each{ _1.instance_exec _1, &block } : pads
              end
            end
          end
        when :>
          each_service(deep: false).find{|pad| extra_filters.all?{|ef| pad =~ ef } }&.then do |pad|
            block ? pad.instance_exec(pad, &block) : pad
          end
        when :>>
          each_service.find{|pad| extra_filters.all?{|ef| pad =~ ef } }&.then do |pad|
            block ? pad.instance_exec(pad, &block) : pad
          end
        when :<
          parent&.then do |pad|
            block ? pad.instance_exec(pad, &block) : pad
          end
        when :<<
          lineage(false).find{|pad| extra_filters.all?{|ef| pad =~ ef } }&.then do |pad|
            block ? pad.instance_exec(pad, &block) : pad
          end
        when :-
          parent&.each_service(deep: false, reverse: true)&.drop_while{|a| a != self }&.drop(1)
          &.find{|pad| extra_filters.all?{|ef| pad =~ ef } }&.then do |pad|
              
            block ? pad.instance_exec(pad, &block) : pad
          end
        when :+
          parent&.each_service(deep: false)&.drop_while{|a| a != self }&.drop(1)
          &.find{|pad| extra_filters.all?{|ef| pad =~ ef } }&.then do |pad|

            block ? pad.instance_exec(pad, &block) : pad
          end
        when :~
          parent&.each_service(deep: false)
          &.find{|pad| extra_filters.all?{|ef| pad =~ ef } }&.then do |pad|

            block ? pad.instance_exec(pad, &block) : pad
          end
        else
          each_service.find{|pad| pad =~ filter and extra_filters.all?{|ef| pad =~ ef } }&.then do |pad|
            block ? pad.instance_exec(pad, &block) : pad
          end
        end
      end

      def []=(*filters, value)
        self[*filters]{ _1 << value }
        value
      end

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

      def self.def! name, klass = nil, *def_a, **def_na, &def_b
        case klass
        when Class
          define_method name do |*a, **na, &b|
            new(klass, name, *def_a, **def_na, **na, &def_b).alter *a, &b
          end
        when true
          define_method name do |*a, **na, &b|
            a = [name, *def_a, *a]
            na = {**def_na, **na}
            instance_exec(a, na, b, self, &def_b).alter *a, **na, &b
          end
        else
          define_method name do |*a, **na, &b|
            a = [name, *def_a, *a]
            na = {**def_na, **na}
            instance_exec a, na, b, self, &def_b
          end
        end
      end

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
            when :-
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
        when :-
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
          &.find{|pad| extra_filters.all?{|ef| pad =~ ef } }&.then do |pad|

            block ? pad.instance_exec(pad, &block) : pad
          end
        else
          each_pad.find{|pad| pad =~ filter and extra_filters.all?{|ef| pad =~ ef } }&.then do |pad|
            block ? pad.instance_exec(pad, &block) : pad
          end
        end
      end

    end
  end
end