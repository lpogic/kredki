require_relative '../kredki'

module Kredki

  PS = POSITION_START = proc{ 0 }
  PC = POSITION_CENTER = proc{ (_1 - _2) / 2 }
  PE = POSITION_END = proc{ _1 - _2 }
  PCS = POSITION_CENTER_START = proc{|a, b| a > b ? POSITION_CENTER[a, b] : POSITION_START[a, b] }
  PCE = POSITION_CENTER_END = proc{|a, b| a > b ? POSITION_CENTER[a, b] : POSITION_END[a, b] }

  module UI
  end

  require_relative 'ui/pad/pad'
  require_relative 'ui/action'
  require_relative 'ui/slide'
  require_relative 'ui/scroll_pad'
  require_relative 'ui/space_pad'
  require_relative 'ui/image_pad'
  require_relative 'ui/text/text_line'
  require_relative 'ui/text/text_area'
  require_relative 'ui/grid/grid_pad'
  require_relative 'ui/input'
  require_relative 'ui/input_area'
  require_relative 'ui/button'
  require_relative 'ui/input_list'

  require_relative "ui/option/option"
  require_relative 'ui/option/options_layer'
  require_relative 'ui/option/tool_menu'

  module UI
    module PadBase
      def_pad :pad!, Pad
      def_pad :space!, SpacePad
      def_pad :grid!, GridPad
      def_pad :scroll!, ScrollPad
      def_pad :image!, ImagePad
      def_pad :xslide!, HorizontalSlide
      def_pad :yslide!, VerticalSlide
      def_pad :text_line!, TextLine
      def_pad :text_area!, TextArea
      def_pad :text!, TextLine
      def_pad :button!, ButtonPad
      def_pad :input!, Input
      def_pad :in!, Input
      def_pad :input_area!, InputArea
      def_pad :ina!, InputArea
      def_pad :input_list!, InputList
      def_pad :inl!, InputList

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

      def_pad :option!, Option, fh: 16

      def_pad :context_menu!, true do
        p0 = self
        @context_menu ||= orphan!.new_pad OptionsLayer do
          p0.on_mouse_button! :secondary do |e|
            attach! p0.action, *p0.translate(*e.xy)
            s[Option]&.focus!
            e.resolve
          end
    
          p0.on_key! :context do |e|
            attach! p0.action, *p0.translate(p0.w / 2, p0.h / 2)
            s[Option]&.focus!
            e.resolve
          end
    
          on! Option::PickEvent do |e|
            detach!
            e.resolve
          end
    
          on_key! :escape do |e|
            detach!
            e.resolve
          end
        end
      end

      def_pad :tool_menu!, ToolMenu

    end#PadBase
  end#UI

  Window.default_action = UI::Action
end#Kredki

include Kredki::UI

class CarryFocusOnTab
  def self.plug_into target
    target.on_key! :tab do |event|
      next_pad = target.layer.keyboard_pad&.then do |p0|
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