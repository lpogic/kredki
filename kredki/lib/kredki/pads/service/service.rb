require 'weakref'
require_relative 'service_event_manager'
require_relative 'service_inherited'
require_relative 'service_filter'

module Kredki
  module Pads
    # Base class of Pads tree nodes.
    class Service
      extend ServiceInherited
      include ServiceFilter

      # Get ancestors.
      def lower_iterator include_self = true
        Enumerator.new do |e|
          c = include_self ? self : lower
          while c && !c.is(Pane)
            e << c
            c = c.lower
          end
        end
      end

      # Get service layer.
      def layer
        is Layer or find_lower Layer
      end

      # Get service pane.
      def pane
        layer&.lower_pad
      end

      # Get service window.
      def window
        pane&.window
      end

      # Get service application.
      def app
        window&.app
      end

      # Get whether +ancestor+ contains self.
      def in? ancestor
        lower_iterator(false).include? ancestor
      end

      # Get whether self contains +descedant+.
      def include? descedant
        descedant.in? self
      end
     
      # Get lower service.
      def lower
        @lower
      end

      # Attach self to +lower+ service.
      def attach lower, at: nil
        raise "service loop detected" if find_lower self
        detach true if @lower
        lower&.push_service self, at: at
      end

      # Detach self.
      def detach transfer = false
        @lower&.remove_upper self
        @lower = nil
      end

      def on event_type, early: false, always: false, do: nil, &block
        @event_manager.manager event_type, block || binding.local_variable_get(:do), early, always
      end

      # Match self with +filter+.
      def =~ filter
        case filter
        when nil
          true
        when Symbol
          if filter.end_with? "?"
            respond_to? filter and send filter
          else
            !!@tags[filter]
          end
        when Service
          filter == self
        when Module, Proc
          filter === self
        when Integer
          pad_index == filter
        when WeakRef
          self =~ filter.__getobj__
        when Array
          filter.all?{|it| self =~ it }
        when Hash
          filter.all?{|key, value| respond_to? key and value === send(key) }
        else
          raise "Unsupported =~ (#{filter} : #{filter.class})"
        end
      end

      # Set whether Pad is tagged with +tag+.
      def set_tag tag, value = true
        return if (c = self.tag tag) == (value = block_given? ? yield(c) : value == Not ? !c : value)
        if value
          @tags[tag] = true
        else
          @tags.delete tag
        end
        true
      end

      # See #set_tag.
      def tag= param
        send_bundle :set_tag, param
      end

      # Get whether Pad is tagged with +tag+.
      def tag tag
        @tags[tag]
      end

      # See #tag.
      def tag? tag
        !!tag
      end

      # Get tags.
      def tags
        @tags.keys
      end

      # Create new job tree.
      def job run = true, &block
        job = AfterJob.new block, 0
        job.run pane if run
        job
      end

      # Push the feature.
      def << feature
        case feature
        when Symbol
          set_tag feature
          eval "#{feature} = WeakRef.new self" if feature.start_with? "$"
          lower&.instance_variable_set feature, self if feature.start_with? "@"
        when Hash
          set **feature
        when Array
          set *feature
        when Proc
          set &feature
        else
          raise "Unsupported << (#{feature} : #{feature.class})"
        end
        self
      end

      # :section: LEVEL 2

      def initialize
        super
        @lower = nil
        @tags = {}
        @services = []
        @event_manager = ServiceEventManager.new
      end

      def sketch_service
        sketch
      end

      def sketch
      end

      def inspect
        "#{self.class}:#{object_id}"
      end

      attr :services
      attr :event_manager

      def service_tree
        @services.map{|it| [it, it.service_tree] }.to_h
      end

      def put klass, *a, at: nil, **ka, &b
        service = klass.new
        push_service service, at: at if at != false
        service.sketch_service
        service.set *a, **ka, &b
        service
      end

      def push_service service, at: nil
        service.update_lower self, at
        case at
        when Integer
          @services.insert at, service
        when Pad
          @services.insert @services.index(at), service
        else
          @services << service
        end
        service
      end

      def service_index service
        @services.index service
      end

      def remove_upper upper
        @services.delete upper
      end

      def update_lower lower, at = nil
        different_lower = @lower != lower
        if different_lower
          @lower = lower
          c_set_lower at
        end
        different_lower
      end

      def c_set_lower at
        @services.each{|it| it.update_lower self }
      end

      def grand_detach
        @services.each{ _1.grand_detach }
      end
      
      def report event, path = false, instant = false
        event.target ||= self
        event_queue = pane&.event_queue
        return unless event_queue
        if path
          path.each do |it|
            event_queue.push event, it.event_manager, true, instant
          end
          path.reverse_each do |it|
            event_queue.push event, it.event_manager, false, instant
          end
        else
          event_queue.push event, @event_manager, true, instant
          event_queue.push event, @event_manager, false, instant
        end
      end
    end
  end
end