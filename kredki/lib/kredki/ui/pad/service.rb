require_relative 'pad_event_manager'
require_relative 'pad_events'
require_relative 'pad_base'
require_relative 'pad_inherited'

module Kredki
  module UI
    # Base class of UI tree nodes.
    class Service
      include PadBase
      include PadEvents
      extend PadInherited

      # Set whether Pad is tagged with +tag+.
      def tag! tag, set = true
        return tag! tag, (yield(self.tag tag)) if block_given?
        @tags[tag] = set
        if plugin = Kredki.plugin(tag)
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

      # Get static pads container.
      def the
        action.the
      end

      # Get ancestors.
      def lineage include_self = true
        Enumerator.new do |e|
          c = include_self ? self : parent
          while c && !c.is_a?(Action)
            e << c
            c = c.parent
          end
        end
      end

      # Get first ancestor matching +filter+.
      def grand filter
        lineage.find{ _1 =~ filter }
      end

      # Get containing layer.
      def layer
        grand Layer
      end

      # Get containing action.
      def action
        layer&.pad_parent
      end

      # Get containing window.
      def window
        action&.window
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
      def attach! parent
        return if @parent == parent
        raise "LOOP" if parent.lineage.find{ _1 == self }
        detach! true if @parent
        parent&.push_service self
      end

      # Detach self.
      def detach! transfer = false
        @parent&.remove_service self
        @parent = nil
      end

      # Use plugin.
      def use! id, *a, **na
        plugin = Kredki.plugin id
        raise_ia id unless plugin
        instance_exec *a, **na, &plugin
      end

      # Play custom local loop.
      def play! id, &block
        @loops[id]&.stop
        @loops[id] = loop! &block
      end

      # Stop custom local loop.
      def stop! id
        @loops.delete(id)&.stop
      end

      # Match self with +filter+.
      def =~(filter)
        case filter
        when Symbol
          !!@tags[filter]
        when Module, Proc
          filter === self
        else
          raise "Unsupported =~ (#{filter} : #{filter.class})"
        end
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

      # :section: LEVEL 2

      def initialize
        super
        @parent = nil
        @tags = {}
        @services = []
        @event_manager = PadEventManager.new
        @loops = {}
      end

      def sketch
      end

      def inspect
        "#{self.class}:#{object_id}"
      end

      attr :services

      def service_tree
        @services.map{ [it, it.service_tree] }.to_h
      end

      def new klass, *a, at: nil, **na, &b
        service = klass.new
        service.sketch_pad
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
        @services.each{ it.set_parent self }
      end

      def grand_pad_detach
        @services.each{ _1.grand_pad_detach }
      end

      def resolve event, aim = false
      end

      def report event, path = true, instant = false
      end
    end
  end
end