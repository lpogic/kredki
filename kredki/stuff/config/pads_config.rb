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
require 'kredki/pads/slide'
require 'kredki/pads/pad/scroll_pad'
require 'kredki/pads/text/navigable_text'
require 'kredki/pads/note'
require 'kredki/pads/notes'
require 'kredki/pads/button'
require 'kredki/pads/check/check'
require 'kredki/pads/radio/group'
require 'kredki/pads/label'
require 'kredki/pads/option/option'
require 'kredki/pads/table/pad'
require 'kredki/pads/list/pad'
require 'kredki/pads/list/tree/pad'
require 'kredki/pads/context/menu'
require 'kredki/pads/toolbar/pad'

module Kredki

  color! :outline_focus, 255, 255, 255, 255
  color! :text_selection, 80, 90, 122, 255
  color! :text_selection_inactive, 70, 80, 92, 155
  color! :text, 255, 255, 255, 255

  module Pads

    define :rectangle!, RectanglePad
    def ellipse! ...
      new(ShapePad, __method__, ...).alter do
        area! do |w, h|
          ellipse! w, h
        end
      end
    end
    def shape! *a, **na, &b
      new ShapePad, __method__, *a, **na do
        area! &b
      end
    end

    define :pad!, RectanglePad
    define :space!, SpacePad
    define :scroll!, ScrollPad
    define :picture!, PicturePad
    define :animation!, AnimationPad
    def text! *a, **na, &b
      new NavigableTextPad, __method__, *a, keyboardy: true, **na, &b
    end
    define :glyph!, GlyphPad
    define :xslide!, HorizontalSlide
    define :yslide!, VerticalSlide
    define :button!, Button
    define :check!, Check
    define :note!, Note
    define :notes!, Notes
    define :label!, Label
    define :option!, Option
    define :table!, Table::Pad
    define :list!, List::Pad
    define :tree!, Tree::Pad

    define :radio!, Radio::Group
    define :context!, Context::Menu
    define :toolbar!, Toolbar::Pad

    layout! nil, Layout::Align.new(Center, Center)
    [Start, Center, End].repeated_permutation 2 do |a, b|
      x = "x#{a.to_s[0]}#{b.to_s[0]}".to_sym
      y = "y#{a.to_s[0]}#{b.to_s[0]}".to_sym
      z = "z#{a.to_s[0]}#{b.to_s[0]}".to_sym
      layout! x, Layout::XWay.new(a, b)
      layout! y, Layout::YWay.new(a, b)
      layout! z, Layout::Align.new(a, b)

      eval <<~RUBY
        def #{x}! *a, **na, &b
          new SpacePad, __method__, *a, layout: :#{x}, **na, &b
        end
        def #{y}! *a, **na, &b
          new SpacePad, __method__, *a, layout: :#{y}, **na, &b
        end
        def #{z}! *a, **na, &b
          new SpacePad, __method__, *a, layout: :#{z}, **na, &b
        end
      RUBY
    end
  end#Pads

  Window.default_scene = Pads::WindowScene

end#Kredki