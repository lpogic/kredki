require_relative 'layer'

module Kredki
  module UI
    module Context
      class PrimaryLayer < Layer

        # :section: LEVEL 2

        def load x, y
          arrange
          action = parent.action
          x_max = action.w - @items.sw 
          x = [x_max, 0].max if x > x_max
          sh = @items.sh
          y = [y - sh, 0].max if y + sh > action.h
          load_common x, y
        end

        def behavior
          super

          on! Item::PickEvent, aim: true do |e|
            if e.target.has_items?
              e.resolve
            else
              pad_detach
            end
          end

          on_key! :escape do |e|
            pad_detach
            e.resolve
          end

          on_mouse_down! do |e|
            pad_detach
          end
        end

        def mouse_enter e
          super
          e.resolve
        end

        def mouse_leave e
          super
          e.resolve
        end

        def mouse_move e
          super
          e.resolve
        end

      end#PrimaryLayer
    end#Context
  end#UI
end#Kredki