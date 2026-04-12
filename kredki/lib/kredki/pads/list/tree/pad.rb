require_relative 'item_group'
require_relative 'item'

module Kredki
  module Pads
    module Tree
      # Tree list pad.
      class Pad < RectanglePad

        # Add new item.
        def item! *a, **ka, &b
          @item_group.item! *a, size_x: 1r, **ka, &b
        end

        # Create and attach select event reaction.
        def on_select ...
          on(Item::SelectEvent, ...)
        end

        # See #on_select.
        def on_select= param
          on_select do: param
        end

        # Get all items.
        def items
          @item_group.items
        end

        # Get selected items.
        def selected_items
          @item_group.selected_items
        end

        # :section: LEVEL 2

        def sketch
          super

          set keyboardy: true
          set fill: :gray
          set layout: :yss

          @item_group = put ItemGroup
        end

        def behavior
          super

          on Item::SelectEvent do |it|
            item = it.target
            source = it.source
            if source.is_a? KeyClickEvent
              if source.key.id == :enter
                item.set_open Not
              else
                if source.ctrl?
                  item.set_selected Not
                else
                  each_upper(Item).each_set{|it| set_selected it == item }
                end
              end
            else
              kb = Kredki.keyboard
              if kb.shift?
                if kb.ctrl?
                  item.set_open Not
                else
                  item.set_selected
                end
              elsif kb.ctrl?
                item.set_selected Not
              else
                each_upper(Item).each{|it| it.set_selected it == item }
                if source.target.is(:@catalog_icon) || layer.mouse_click_combo > 1
                  item.set_open Not
                end
              end
            end
          end

          on_focus_leave do
            each_upper(Item).each_set selected: false
          end
        end

        def put_pad pad, at = nil
          super
        end

      end#List
    end#Tree
  end#Pads
end#Kredki