
require_relative 'pad'
require_relative 'item_group'
require_relative 'layer'
require_relative 'primary_layer'
require_relative 'secondary_layer'
require_relative 'item'

module Kredki
  module UI
    module Context

      # Reopen class to avoid circular depedency.
      class ItemGroup
        def item! *a, **na, &b
          new Item, *a, w: 1r, **na, &b
        end
      end
      
      # Context menu service.
      class Menu < Service

        attr :context_layer

        # Add new item.
        def item! ...
          @context_layer.item_group.item!(...)
        end

        # Create and attach pick event resolver.
        def on_pick! ...
          on!(Item::PickEvent, ...)
        end

        # See #on_pick!.
        def on_pick= param
          on_pick! do: param
        end

        # Set primary pad width.
        def w! ...
          @context_layer.items.w!(...)
        end

        # See #w!.
        def w= param,
          send_ahp :w!, param
        end

        # Get primary pad width.
        def w
          @context_layer.items.w
        end

        # Set primary pad height.
        def h! ...
          @context_layer.items.h!(...)
        end

        # See #h!.
        def h= param,
          send_ahp :h!, param
        end

        # Get primary pad height.
        def h
          @context_layer.items.h
        end

        # Set primary pad width and height.
        def wh! ...
          @context_layer.items.wh!(...)
        end

        # See #wh!.
        def wh= param,
          send_ahp :wh!, param
        end

        # Get primary pad width and height.
        def wh
          @context_layer.items.wh
        end

        # :section: LEVEL 2

        def initialize
          super
        
          @context_layer = new PrimaryLayer
        end

        def set_parent parent, at = nil
          super and (
            @parent_events&.each{ _1.detach! }
            @parent_events = []

            @parent_events[] = parent.on_mouse_click! :secondary do |e|
              @context_layer.load! *e.xy
              @context_layer[Item]&.keyboard_request
              e.resolve
            end
      
            @parent_events[] = parent.on_key! :context do |e|
              @context_layer.load! *parent.translate(parent.sx / 2, parent.sy / 2)
              @context_layer[Item]&.keyboard_request
              e.resolve
            end
          )
        end

      end#Menu
    end#Context
  end#UI
end#Kredki