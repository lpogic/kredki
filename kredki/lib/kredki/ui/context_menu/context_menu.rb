
require_relative 'context_pad'
require_relative 'context_option_group'
require_relative 'context_layer'
require_relative 'context_primary_layer'
require_relative 'context_secondary_layer'
require_relative 'context_option'

module Kredki
  module UI
    # Reopening class to avoid circular depedency 
    class ContextOptionGroup
      def option! *a, **na, &b
        new ContextOption, *a, w: 100r, **na, &b
      end
    end
    
    class ContextMenu < Service
      extend HasEventResolvers

      attr :context_layer

      def option! ...
        @context_layer.option_group.option!(...)
      end

      event_resolver :on_pick!, Option::PickEvent

      param_delegate "@context_layer.options",
        :w, :h, :wh

      def initialize
        super
      
        @context_layer = new ContextPrimaryLayer
      end

      def set_parent parent
        super and (
          @parent_events&.each{ _1.detach! }
          @parent_events = []

          @parent_events[] = parent.on_mouse_click! :secondary do |e|
            @context_layer.load! *e.xy
            @context_layer[Option]&.focus!
            e.resolve
          end
    
          @parent_events[] = parent.on_key! :context do |e|
            @context_layer.load! *parent.translate(parent.sx / 2, parent.sy / 2)
            @context_layer[Option]&.focus!
            e.resolve
          end
        )
      end

    end#ContextMenu
  end#UI
end#Kredki