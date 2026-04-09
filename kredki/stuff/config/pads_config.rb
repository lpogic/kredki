# This is pads config loaded by default.
#
# If you don't want to load the default configuration, you can set the path to your own:
#
#   require 'kredki/setup'
#   Kredki.pads_config = './cutom_pads_config.rb'
#   require 'kredki'
#   ...
# This way 'custom_pads_config.rb' will be loaded instead of the current file.

require 'kredki/pads/pad/space_pad'
require 'kredki/pads/pad/picture_pad'
require 'kredki/pads/pad/glyph_pad'
require 'kredki/pads/pad/text_pad'
require 'kredki/pads/pad/animation_pad'
require 'kredki/pads/slider/slider'
require 'kredki/pads/slider/slider_x'
require 'kredki/pads/slider/slider_y'
require 'kredki/pads/pad/scroll_pad'
require 'kredki/pads/text/navigable_text_pad'
require 'kredki/pads/note'
require 'kredki/pads/notes'
require 'kredki/pads/button'
require 'kredki/pads/checkbox/checkbox'
require 'kredki/pads/radio/group'
require 'kredki/pads/label'
require 'kredki/pads/option/option'
require 'kredki/pads/table/pad'
require 'kredki/pads/list/pad'
require 'kredki/pads/list/tree/pad'
require 'kredki/pads/context/menu'
require 'kredki/pads/toolbar/pad'

module Kredki

  color! :stroke_focus, 255, 255, 255, 255
  color! :text_selection, 80, 90, 122, 255
  color! :text_selection_inactive, 70, 80, 92, 155
  color! :text, 255, 255, 255, 255

  module Pads
    class Pad

      rectangle! RectanglePad
      def ellipse! ...
        put(ShapePad, __method__, ...).set do
          set_area do |sx, sy|
            ellipse sx, sy
          end
        end
      end
      def shape! *a, **ka, &b
        put ShapePad, __method__, *a, **ka do
          set_area &b
        end
      end

      pad! RectanglePad
      space! SpacePad
      scroll! ScrollPad
      picture! PicturePad
      animation! AnimationPad
      def text! *a, **ka, &b
        put NavigableTextPad, __method__, *a, keyboardy: true, **ka, &b
      end
      glyph! GlyphPad
      slider_x! SliderX
      slider_y! SliderY
      button! Button
      checkbox! Checkbox
      note! Note
      notes! Notes
      label! Label
      option! Option
      table! Table::Pad
      list! List::Pad
      tree! Tree::Pad
      radio! Radio::Group
      context_menu! Context::Menu
      toolbar! Toolbar::Pad

      Pads.layout! nil, Layout::Align.new(Center, Center)
      [Start, Center, End].repeated_permutation 2 do |a, b|
        x = "x#{a.to_s[0]}#{b.to_s[0]}".to_sym
        y = "y#{a.to_s[0]}#{b.to_s[0]}".to_sym
        z = "z#{a.to_s[0]}#{b.to_s[0]}".to_sym
        Pads.layout! x, Layout::XWay.new(a, b)
        Pads.layout! y, Layout::YWay.new(a, b)
        Pads.layout! z, Layout::Align.new(a, b)

        eval <<~RUBY
          def #{x}! *a, **ka, &b
            put SpacePad, __method__, *a, layout: :#{x}, **ka, &b
          end
          def #{y}! *a, **ka, &b
            put SpacePad, __method__, *a, layout: :#{y}, **ka, &b
          end
          def #{z}! *a, **ka, &b
            put SpacePad, __method__, *a, layout: :#{z}, **ka, &b
          end
        RUBY
      end

      def service! *a, **ka, &b
        put(Class.new(Service, &b), __method__, *a, **ka)
      end
    end#Pad
  end#Pads

  Kredki.app = Pads::Application
end#Kredki