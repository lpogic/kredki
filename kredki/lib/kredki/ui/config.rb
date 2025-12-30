# This is ui config loaded by default.
#
# If you don't want to load the default configuration, you can set the path to your own in the global variable $kredki_ui_config before require 'kredki':
#   $kredki_ui_config = './cutom_ui_config.rb'
#   require 'kredki'
#   ...
# This way 'custom_ui_config.rb' will be loaded instead of the current file.

require_relative 'slide'
require_relative 'scroll_pad'
require_relative 'space_pad'
require_relative 'picture_pad'
require_relative 'text_pad'
require_relative 'animation_pad'
require_relative 'text/navigable_text'
require_relative 'note'
require_relative 'notes'
require_relative 'button'
require_relative 'check'
require_relative 'labeled_check'
require_relative 'radio/group'
require_relative 'label'
require_relative 'option/option'
require_relative 'table/pad'
require_relative 'list/pad'
require_relative 'list/tree/pad'
require_relative 'context/menu'
require_relative 'toolbar/pad'

module Kredki

  color! :outline_focus, 182, 142, 0, 255
  color! :text_selection, 70, 80, 122, 255
  color! :text_selection_inactive, 70, 80, 112, 155
  color! :text, 255, 255, 255, 255

  module UI
    module PadBase
      define :pad!, RectanglePad
      define :space!, SpacePad
      define :scroll!, ScrollPad
      define :picture!, PicturePad
      define :animation!, AnimationPad
      def text! *a, **na, &b
        new NavigableText, :text!, *a, keyboardy: true, **na, &b
      end
      define :xslide!, HorizontalSlide
      define :yslide!, VerticalSlide
      define :button!, Button
      define :check!, Check
      define :labeled_check!, LabeledCheck
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

    end#PadBase
  end#UI

  Window.default_action = UI::Action

  plugin! :carry_focus_on_tab do
    on_key_down! :tab do |event|
      next_pad = layer.keyboard_pad&.then do |p0|
        each_pad(reverse: event.shift?, deep: true)
          .lazy
          .drop_while{|p1| p0 != p1 }
          .drop(1)
          .filter{ it.keyboardy? && it.show? }
          .first
      end || each_pad(reverse: event.shift?, deep: true)
        .lazy
        .filter{ it.keyboardy? && it.show? }
        .first
      next_pad.keyboard_request if next_pad
    end
  end
end#Kredki