require_relative 'item_group'
require_relative 'item'

module Kredki
  module Pads
    module Tree
      # Tree list pad.
      class Pad < RectanglePad

        # Add new item.
        def item! *a, **na, &b
          @item_group.item! *a, w: 1r, **na, &b
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

          keyboardy!
          fill! :gray
          layout! :yss

          @item_group = new ItemGroup
        end

        def behavior
          super

          on Item::PickEvent do |it|
            item = it.target
            source = it.source
            if source.is_a? KeyEvent
              if source.key.id == :enter
                item.open! :not
              else
                if source.shift?
                  item.select! :not
                else
                  each_fd(Item).each_alter{|it| selected! it == item }
                end
              end
            else
              kb = Kredki.keyboard
              if kb.shift?
                if kb.ctrl?
                  item.open! :not
                else
                  item.selected!
                end
              elsif kb.ctrl?
                item.selected! :not
              else
                each_fd(Item).each_alter{|it| selected! it == item }
                item.open! :not
              end
            end
          end

          on_focus_leave do
            each_fd(Item).each_alter selected: false
          end
        end

      end#List
    end#Tree
  end#Pads
end#Kredki