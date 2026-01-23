# This is ui config loaded by default.
#
# If you don't want to load the default configuration, you can set the path to your own in the global variable $kredki_ui_config before require 'kredki':
#   $kredki_ui_config = './cutom_ui_config.rb'
#   require 'kredki'
#   ...
# This way 'custom_ui_config.rb' will be loaded instead of the current file.

require_relative 'pad/space_pad'
require_relative 'pad/picture_pad'
require_relative 'pad/text_pad'
require_relative 'pad/animation_pad'
require_relative 'slide'
require_relative 'pad/scroll_pad'
require_relative 'text/navigable_text'
require_relative 'note'
require_relative 'notes'
require_relative 'button'
require_relative 'check/check'
require_relative 'radio/group'
require_relative 'label'
require_relative 'option/option'
require_relative 'table/pad'
require_relative 'list/pad'
require_relative 'list/tree/pad'
require_relative 'context/menu'
require_relative 'toolbar/pad'

module Kredki

  color! :outline_focus, 0, 142, 182, 255
  color! :text_selection, 70, 80, 122, 255
  color! :text_selection_inactive, 70, 80, 112, 155
  color! :text, 255, 255, 255, 255

  module UI
    layout! nil, Layout::Align.new(:center, :center)
    [:start, :center, :end].repeated_permutation 2 do |it|
      layout! "x#{it[0].to_s[0]}#{it[1].to_s[0]}".to_sym, Layout::XWay.new(*it)
      layout! "y#{it[0].to_s[0]}#{it[1].to_s[0]}".to_sym, Layout::YWay.new(*it)
      layout! "z#{it[0].to_s[0]}#{it[1].to_s[0]}".to_sym, Layout::Align.new(*it)
    end

    module GlobalServices
      define :pad!, RectanglePad
      define :space!, SpacePad
      define :scroll!, ScrollPad
      define :picture!, PicturePad
      define :animation!, AnimationPad
      def text! *a, **na, &b
        new NavigableTextPad, :text!, *a, keyboardy: true, **na, &b
      end
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

    end#GlobalServices
  end#UI

  Window.default_scene = UI::WindowScene

  plugin! :carry_focus_on_tab do
    on_key_press :tab do |event|
      next_pad = layer.keyboard_pad&.then do |p0|
        each_pad(reverse: event.shift?, deep: true)
          .lazy
          .drop_while{|p1| p0 != p1 }
          .drop(1)
          .filter{|it| it.keyboardy? && it.show? }
          .first
      end || each_pad(reverse: event.shift?, deep: true)
        .lazy
        .filter{|it| it.keyboardy? && it.show? }
        .first
      next_pad.keyboard_request if next_pad
    end
  end
end#Kredki