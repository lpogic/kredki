
require_relative 'context_pad'
require_relative 'context_item_group'
require_relative 'context_layer'
require_relative 'context_primary_layer'
require_relative 'context_secondary_layer'
require_relative 'context_item'

module Kredki
  module UI
    # Reopening class to avoid circular depedency 
    class ContextItemGroup
      def item! *a, **na, &b
        new ContextItem, *a, w: 100r, **na, &b
      end
    end
    
    class ContextMenu < Service
      extend HasEventResolvers

      attr :context_layer

      def item! ...
        @context_layer.item_group.item!(...)
      end

      event_resolver :on_pick!, Item::PickEvent

      param_delegate "@context_layer.items",
        :w, :h, :wh

      def initialize
        super
      
        @context_layer = new ContextPrimaryLayer
      end

      def set_parent parent, at = nil
        super and (
          @parent_events&.each{ _1.detach! }
          @parent_events = []

          @parent_events[] = parent.on_mouse_click! :secondary do |e|
            @context_layer.load! *e.xy
            @context_layer[Item]&.focus!
            e.resolve
          end
    
          @parent_events[] = parent.on_key! :context do |e|
            @context_layer.load! *parent.translate(parent.sx / 2, parent.sy / 2)
            @context_layer[Item]&.focus!
            e.resolve
          end
        )
      end

    end#ContextMenu
  end#UI
end#Kredki