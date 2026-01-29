require 'weakref'
require_relative 'service_event_manager'
require_relative 'service_inherited'
require_relative 'service_filter'

module Kredki
  module Pads
    # Base class of Pads tree nodes.
    class Service
      extend ServiceInherited
      include Pads
      include ServiceFilter

      # Set whether Pad is tagged with +tag+.
      def tag! tag, set = true
        return tag! tag, (yield(self.tag tag)) if block_given?
        @tags[tag] = set
        if tag.start_with? "$"
          eval "#{tag} = WeakRef.new self"
        end
        if plugin = window&.plugin(tag)
          if set
            instance_exec &plugin
          else
          end
        end
        true
      end

      # See #tag!.
      def tag= param
        send_ahp :tag!, param
      end

      # Get whether Pad is tagged with +tag+ _or_ all tags if +tag+ is +nil+.
      def tag tag = nil
        tag ? @tags[tag] : @tags.keys
      end

      # Get ancestors.
      def lineage include_self = true
        Enumerator.new do |e|
          c = include_self ? self : parent
          while c && c.isnt(WindowScene)
            e << c
            c = c.parent
          end
        end
      end

      # Get Kredki::Pads::Layer ancestor.
      def layer
        is Layer or fa Layer
      end

      # Get Kredki::WindowScene ancestor.
      def window
        layer&.pad_parent
      end

      # Get Kredki::Application ancestor.
      def application
        window&.application
      end

      # Get whether +grand+ contains self.
      def in? grand
        lineage(false).include? grand
      end

      # Get whether self contains +child+.
      def include? child
        child.in? self
      end
     
      # Get parent
      def parent
        @parent
      end

      # Attach self to +parent+.
      def attach parent
        return if @parent == parent
        raise "LOOP" if parent.lineage.find{ _1 == self }
        detach true if @parent
        parent&.push_service self
      end

      # Detach self.
      def detach transfer = false
        @parent&.remove_service self
        @parent = nil
      end

      # Use plugin.
      def use! id, *a, **na
        plugin = window.plugin id
        raise_ia id unless plugin
        instance_exec *a, **na, &plugin
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
        when Module, Proc
          filter === self
        when Integer
          pad_index == filter
        when Array
          filter.all?{|it| self =~ it }
        when Hash
          filter.all?{|key, value| respond_to? key and value === send(key) }
        else
          raise "Unsupported =~ (#{filter} : #{filter.class})"
        end
      end

      # Get whether match all filters.
      def is *filters, &block
        self =~ filters && self =~ block ? self : false
      end

      # Get whether not match all filter.
      def isnt *filters, &block
        filters.all?{ self !~ filters } && (!block || self !~ block ? self : false)
      end

      # Push the feature.
      def << feature
        case feature
        when Symbol
          tag! feature
        when Hash
          alter **feature
        when Array
          alter *feature
        when Proc
          alter &feature
        else
          raise "Unsupported << (#{feature} : #{feature.class})"
        end
        self
      end

      # Create new job tree.
      def job run = true, &block
        job = AfterJob.new block, 0
        job.run window if run
        job
      end

      # :section: LEVEL 2

      def initialize
        super
        @parent = nil
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

      def new klass, *a, at: nil, **na, &b
        service = klass.new
        service.sketch_service
        push_service service, at if at != false
        service.alter *a, **na, &b
        service
      end

      def push_service service, at = nil
        service.set_parent self, at
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

      def remove_service service
        @services.delete service
      end

      def set_parent parent, at = nil
        if new_parent = @parent != parent
          @parent = parent
          c_set_parent at
        end
        new_parent
      end

      def c_set_parent at
        @services.each{|it| it.set_parent self }
      end

      def grand_pad_detach
        @services.each{ _1.grand_pad_detach }
      end

      def report event, path = false, instant = false
        event.target ||= self
        event_queue = window&.event_queue
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