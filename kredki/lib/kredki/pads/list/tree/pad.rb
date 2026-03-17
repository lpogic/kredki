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

        # Create and attach pick event reaction.
        def on_pick ...
          on(Item::PickEvent, ...)
        end

        # See #on_pick.
        def on_pick= param
          on_pick do: param
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

          on Item::PickEvent do |it|
            item = it.target
            source = it.source
            if source.is_a? KeyEvent
              if source.key.id == :enter
                item.set_open Not
              else
                if source.shift?
                  item.set_select Not
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
                each_upper(Item).each_set{|it| set_selected it == item }
                item.set_open Not
              end
            end
          end

          on_focus_leave do
            each_upper(Item).each_set selected: false
          end
        end

      end#List
    end#Tree
  end#Pads
end#Kredki