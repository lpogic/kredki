
require_relative 'pad'
require_relative 'item_group'
require_relative 'layer'
require_relative 'primary_layer'
require_relative 'secondary_layer'
require_relative 'item'

module Kredki
  module Pads
    module Context

      # Reopen class to avoid circular depedency.
      class ItemGroup

        # Add new item.
        def item!(...)
          put(Item, :item!, size_x: 1r).set(...)
        end
      end
      
      # Context menu service.
      class Menu < Service

        attr :context_layer

        def items
          @context_layer.items
        end

        # Add new item.
        def item! ...
          @context_layer.item_group.item!(...)
        end

        # Create and attach select event reaction.
        def on_select ...
          on(Item::SelectEvent, ...)
        end

        # See #on_select.
        def on_select= param
          on_select do: param
        end

        # :section: LEVEL 2

        def initialize
          super
        
          @context_layer = put PrimaryLayer
        end

        def update_lower lower, at = nil
          if super
            @lower_events&.each{ _1.cancel }

            secondary_mouse_click = lower.on_mouse_click :secondary do |e|
              @context_layer.load *e.xy
              @context_layer.find_upper(Item)&.keyboard_request
              e.close
            end
      
            context_key = lower.on_key :context do |e|
              @context_layer.load *lower.translate(lower.area_x / 2, lower.area_y / 2)
              @context_layer.find_upper(Item)&.keyboard_request
              e.close
            end

            @lower_events = [secondary_mouse_click, context_key]
          end
        end

      end#Menu
    end#Context
  end#Pads
end#Kredki