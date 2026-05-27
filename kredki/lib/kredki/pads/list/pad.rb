require_relative 'item_group'
require_relative 'item'

module Kredki
  module Pads
    module List
      class Pad < RectanglePad
        
        # Add new item.
        def item! *a, **ka, &b
          @item_group.item! *a, size_x: 1r, **ka, &b
        end
        
        reaction Item::SelectEvent, :on_select

        # Get all items.
        def items
          @item_group.items
        end

        # Get selected items.
        def selected_items
          @item_group.selected_items
        end

        # :section: LEVEL 2

        def initialize
          super

          @item_group = put ItemGroup
        end

        def sketch
          super

          set_keyboardy true
          set_fill :gray
          set_layout :yss
          set_size_y Fit
        end

        def behavior
          super

          on Item::SelectEvent do |e|
            item = e.target
            kb = Kredki.keyboard
            if kb.shift?
              item.set_selected
            elsif kb.ctrl?
              item.set_selected Not
            else
              each_upper(Item).each{|it| it.set_selected it == item }
            end
          end
          
        end

        def presence
          super
          
          Event.each(
            on_focus_enter,
            on_focus_leave,
            do: method(:repaint)
          )
        end

        def repaint event = nil
          super

          items.each{|it| it.repaint nil, keyboard_in }
        end

        def put subject, *a, at: nil, **ka, &b
          case subject
          when Item
            subject.detach
            @item_group.put_service subject, *a, at: at, **ka, &b
          else super
          end
        end

      end#Pad
    end#List
  end#Pads
end#Kredki