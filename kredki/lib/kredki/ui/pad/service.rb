require_relative 'pad_event_manager'
require_relative 'pad_events'
require_relative 'pad_base'
require_relative 'pad_inherited'
require 'forwardable'
require 'weakref'
require 'kredki-core/context/context'
require 'kredki-core/flagship'
require 'kredki-core/block_shape_area'

module Kredki
  module UI
    class Service
      include PadBase
      include Alterable
      include Context
      include PadEvents
      extend Forwardable
      extend Flagship
      extend PadInherited

      def <<(arg)
        case arg
        when Symbol
          tag! arg
        when Hash
          alter **arg
        when Array
          alter *arg
        when Proc
          alter &arg
        when Module
          use! arg
        else
          raise "Unsupported << (#{arg} : #{arg.class})"
        end
        self
      end

      param def tag! tag
        @tags[tag] = true
        layer.weak_tag tag.to_s[1..], WeakRef.new(self) if tag.start_with? "@"
      end, get: def tag
        @tags.keys
      end

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

      def lineage include_self = true
        Enumerator.new do |e|
          c = include_self ? self : parent
          while c && !c.is_a?(Action)
            e << c
            c = c.parent
          end
        end
      end

      def grand filter
        lineage.find{ _1 =~ filter }
      end

      def layer
        grand Layer
      end

      def action
        layer&.pad_parent
      end

      def in? grand
        lineage(false).include? grand
      end

      def include? child
        child.in? self
      end
     
      attr :parent, :services

      alias_method :a, :action

      def s
        self
      end

      def clear!
        clear_pads
      end

      def attach! parent
        return if @parent == parent
        raise "LOOP" if parent.lineage.find{ _1 == self }
        detach! true if @parent
        parent&.push_service self
      end

      def detach! transfer = false
        @parent&.remove_service self
        @parent = nil
      end

      def use! extension, *a, **na, &b
        extension.plug_into self, *a, **na, &b if extension.respond_to? :plug_into
      end

      #internal api

      def initialize
        super
        @action = nil
        @parent = nil
        @tags = {}
        @services = []
        @event_manager = PadEventManager.new
      end

      def sketch p0
      end

      def inspect
        "#{self.class}:#{object_id}"
      end

      def service_tree
        @services.map{ [it, it.service_tree] }.to_h
      end

      def new klass, *a, at: nil, **na, &b
        service = klass.new
        service.alter_begin
        service.sketch service
        push_service service, at if at != false
        service.alter *a, **na, &b
        service.alter_commit
        service
      end

      def push_service service, at = nil
        service.set_parent self #, at
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

      def remove_service service
        @services.delete service
      end

      def set_parent parent
        if new_parent = @parent != parent
          @parent = parent
          c_set_parent
        end
        new_parent
      end

      def c_set_parent
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