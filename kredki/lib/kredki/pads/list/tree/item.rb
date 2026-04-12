module Kredki
  module Pads
    module Tree
      # Tree list item model.
      class Item < List::Item

        # Add new subitem.
        def item! *a, **ka, &b
          at = (lower.subitems(self).last || self).pad_index + 1
          open = self.open
          lower.item! *a, scenic: open, layoutic: open, size_x: 1r, at: at, level: level + 1, **ka, &b
          set_leaf false if @leaf.nil?
        end

        # Set whether is opened.
        def set_open value = true, &block
          return if (c = open) == (value = block ? block[c] : value == Not ? !c : value)
          update_open value
          lower&.update_open
          true
        end

        # See #set_open.
        def open= param
          send_bundle :set_open, param
        end

        # Get whether is opened.
        def open
          @open || @open.nil?
        end

        # Set whether is leaf.
        def set_leaf value = true, &block
          return if (c = leaf) == (value = block ? block[c] : value == Not ? !c : value)
          @leaf = value
          update_icon
          true
        end

        # See #set_leaf.
        def leaf= param
          send_bundle :set_leaf, param
        end

        # Get whether is leaf.
        def leaf
          @leaf || @leaf.nil?
        end

        # Set level.
        def set_level level
          return if @level == level
          @level = level
          update_level
          true
        end

        # See #set_level.
        def level= param
          send_bundle :set_level, param
        end
        
        # Get level
        def level
          @level || 0
        end

        # :section: LEVEL 2

        def initialize
          super

          @icon_space = put SpacePad, size: [:y, 1r]
        end

        def sketch
          super

          update_icon
        end

        def update_level
          set_margin_xs 4 + level * get_size_y * 0.5
        end

        def update_open open
          @open = open
          update_icon
        end

        def update_icon
          @icon_space.clear
          if leaf
            default_leaf_icon
          elsif open
            default_catalog_open_icon
          else
            default_catalog_icon
          end
        end

        def default_leaf_icon
          @icon_space.put Pad, size: 1r, fill: :text do
            set_area do
              ellipse 1/5r, 1/5r
            end
          end
        end

        def default_catalog_icon
          @icon_space.put RectanglePad, :@catalog_icon, keyboardy: false, fill: 0, size: 1r do
            set_stroke fill: :text, width: 2, cap: :round
            set_mouse_cursor :pointer
            set_area do |sx, sy|
              jump sx * 0.4, sy * 0.35
              line sx * 0.6, sy * 0.5
              line sx * 0.4, sy * 0.65
            end
          end
        end

        def default_catalog_open_icon
          @icon_space.put RectanglePad, :@catalog_icon, keyboardy: false, fill: 0, size: 1r do
            set_stroke fill: :text, width: 2, cap: :round
            set_mouse_cursor :pointer
            set_area do |sx, sy|
              jump sx * 0.35, sy * 0.4
              line sx * 0.5, sy * 0.6
              line sx * 0.65, sy * 0.4
            end
          end
        end

      end#Item
    end#Tree
  end#Pads
end#Kredki
