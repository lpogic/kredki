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

        # Set whether is catalogic. 
        def set_catalogic value = true, &block
          return if (c = catalogic) == (value = block ? block[c] : value == Not ? !c : value)
          @catalogic = value
          true
        end

        # See #set_catalogic.
        def catalogic= param
          send_bundle :set_catalogic, param
        end

        # Get whether is catalogic.
        def catalogic
          @catalogic || @catalogic.nil?
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

      end#List
    end#Tree
  end#Pads
end#Kredki