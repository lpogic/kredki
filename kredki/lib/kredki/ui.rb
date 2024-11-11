require_relative '../kredki'

module Kredki

  PS = POSITION_START = proc{ 0 }
  PC = POSITION_CENTER = proc{ (_2 - _1) / 2 }
  PE = POSITION_END = proc{ _2 - _1 }
  PCS = POSITION_CENTER_START = proc{|a, b| a > b ? POSITION_START[a, b] : POSITION_CENTER[a, b] }

  module UI
  end

  require_relative 'ui/pad/pad'
  require_relative 'ui/action'
  require_relative 'ui/input'
  require_relative 'ui/button'
  require_relative 'ui/slide'
  require_relative 'ui/scroll_pad'
  require_relative 'ui/spacer_pad'
  require_relative 'ui/slice_pad'
  require_relative 'ui/place_pad'
  require_relative 'ui/image_pad'
  require_relative 'ui/text/text_line'
  require_relative 'ui/text/text_column'
  require_relative 'ui/editor'
  require_relative 'ui/grid/grid_pad'

  module UI
    module PadBase
      def_pad :pad!, Pad
      def_pad :slice!, SlicePad
      def_pad :place!, PlacePad
      def_pad :grid!, GridPad
      def_pad :scroll!, ScrollPad
      def_pad :margin!, SpacerPad
      def_pad :image!, ImagePad
      def_pad :xslide!, HorizontalSlide
      def_pad :yslide!, VerticalSlide
      def_pad :text_line!, TextLine
      def_pad :text_column!, TextColumn
      def_pad :text!, TextColumn
      def_pad :editor!, TextLineEditor
      def_pad :column_editor!, TextColumnEditor
      def_pad :button!, ButtonPad
      def_pad :input!, Input

      def_pad :list! do |a, na, b|
        grid! *a, direction: :row, autosized: true, **na, &b
      end

      def_pad :xlist! do |a, na, b|
        grid! *a, direction: :col, autosized: true, **na, &b
      end

      def_pad :ylist! do |a, na, b|
        grid! *a, direction: :row, autosized: true, **na, &b
      end

      def_pad :btn! do |a, na, b|
        button! *a, **na do
          on_click! &b
        end
      end
    end
  end

  Window.default_action = UI::Action
end

class CarryFocusOnTab
  def self.plug_into target
    target.on_key! :tab do |event|
      next_pad = target.action.keyboard_pad&.then do |p0|
        target.each_pad(reverse: event.shift?, deep_first: true)
          .lazy
          .drop_while{|p1| p0 != p1 }
          .drop(1)
          .filter{ _1.keyboardy? }
          .first
      end || target.each_pad(reverse: event.shift?, deep_first: true)
        .lazy
        .filter{ _1.keyboardy? }
        .first
      next_pad.focus_gain if next_pad
    end
  end
end