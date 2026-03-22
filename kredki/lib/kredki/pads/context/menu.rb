
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

        # Create and attach pick event reaction.
        def on_pick ...
          on(Item::PickEvent, ...)
        end

        # See #on_pick.
        def on_pick= param
          on_pick do: param
        end

        # Set primary pad size in the X axis.
        def set_size_x ...
          @context_layer.items.set_size_x(...)
        end

        # See #set_size_x.
        def size_x= param
          send_bundle :set_size_x, param
        end

        # Get primary pad size in the X axis.
        def size_x
          @context_layer.items.size_x
        end

        # Set primary pad size in the Y axis.
        def set_size_y ...
          @context_layer.items.set_size_y(...)
        end

        # See #set_size_y.
        def size_y= param
          send_bundle :set_size_y, param
        end

        # Get primary pad size in the Y axis.
        def size_y
          @context_layer.items.size_y
        end

        # Set primary pad size.
        def set_size ...
          @context_layer.items.set_size(...)
        end

        # See #set_size.
        def size= param
          send_bundle :set_size, param
        end

        # Get primary pad width and height.
        def size
          @context_layer.items.size
        end

        # :section: LEVEL 2

        def initialize
          super
        
          @context_layer = put PrimaryLayer
        end

        def update_lower lower, at = nil
          if super
            @lower_events&.each{ _1.detach }

            secondary_mouse_click = lower.on_mouse_click :secondary do |e|
              @context_layer.load *e.xy
              @context_layer.find_upper(Item)&.keyboard_request
              e.close
            end
      
            context_key = lower.on_key :context do |e|
              @context_layer.load *lower.translate(lower.sx / 2, lower.sy / 2)
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