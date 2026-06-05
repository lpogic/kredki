
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

        def delete_upper upper, system_call
          super
          lower(Item)&.dropdown_disable if !upper(Item)
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

        reaction Item::SelectEvent, :on_select

        # :section: LEVEL 2

        def initialize
          super
        
          @context_layer = put PrimaryLayer
        end

        def behavior
          super

          on_select do |e|
            if e.target[Context::Item]
              e.close
            else
              @context_layer.pad_detach
            end
          end
        end

        def update_lower lower, at = nil
          if super
            @lower_events&.each{ _1.cancel }

            if lower
              secondary_mouse_click = lower.on_mouse_click :secondary do |e|
                @context_layer.load *e.xy
                @context_layer[Item]&.keyboard_request
                e.close
              end
        
              context_key = lower.on_key :context do |e|
                @context_layer.load *lower.translate(lower.area_x / 2, lower.area_y / 2)
                @context_layer[Item]&.keyboard_request
                e.close
              end

              @lower_events = [secondary_mouse_click, context_key]
            else
              @lower_events = []
            end
          end
        end

      end#Menu
    end#Context
  end#Pads
end#Kredki