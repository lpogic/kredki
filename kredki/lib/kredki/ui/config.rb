require_relative 'slide'
require_relative 'scroll_pad'
require_relative 'space_pad'
require_relative 'image_pad'
require_relative 'text_pad'
require_relative 'animation_pad'
require_relative 'text/navigable_text'
require_relative 'note'
require_relative 'notes'
require_relative 'button'
require_relative 'check'
require_relative 'check_label'
require_relative 'radio/radio_group'
require_relative 'label'
require_relative 'option/option'
require_relative 'table/table'
require_relative 'list/list'
require_relative 'list/tree_list'
require_relative 'context_menu/context_menu'
require_relative 'toolbar_menu/toolbar_menu'

module Kredki
  module UI
    module PadBase
      define :pad!, RectanglePad
      define :space!, SpacePad
      define :scroll!, ScrollPad
      define :image!, ImagePad
      define :animation!, AnimationPad
      def text! *a, **na, &b
        new NavigableText, :text!, *a, keyboardy: true, **na, &b
      end
      define :xslide!, HorizontalSlide
      define :yslide!, VerticalSlide
      define :button!, Button
      define :check!, Check
      define :check_label!, CheckLabel
      define :note!, Note
      define :notes!, Notes
      define :label!, Label
      define :option!, Option
      define :table!, Table
      define :list!, List
      define :tree!, TreeList

      define :radio!, RadioGroup
      define :context!, ContextMenu
      define :toolbar!, ToolbarMenu

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