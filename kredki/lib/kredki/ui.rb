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

  require_relative "ui/layout/aim"
  require_relative "ui/layout/row"
  require_relative "ui/layout/column"
  require_relative "ui/layout/aim"
  require_relative "ui/option/option"
  require_relative 'ui/option/dropdown_layer'
  require_relative 'ui/option/dropright_layer'
  require_relative 'ui/option/context_layer'
  require_relative 'ui/option/scroll_dropdown_layer'

  module UI

    class Attribute
      model :value, :updater do
        @links = []
      end
    
      def link link
        @links << link
      end
    
      def update
        @links.each{|link| link.update }
        @updater&.call
      end
    
      def set value
        @value = value
        update
      end
    
      def get
        @value
      end
    end

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

      def_pad :btn! do |a, na, b|
        button! *a, **na do
          on_click! &b
        end
      end

      def_pad :option!, Option

      class RightTriangle < Kredki::Area
        def repaint
          stroke_width! 3
          move_to! 0, 0
          line_to! @w, @h / 2
          line_to! 0, @h
        end
      end

      def_pad :dropdown! do |a, na, b|
        @dropdown ||= orphan!.new_pad DropdownLayer, master: self
        options = @dropdown.options.alter(*a, **na)
        options.instance_exec options, @dropdown, &b if b
        options
      end
        
      def_pad :dropright!, true do
        @dropright ||= orphan!.new_pad DroprightLayer, master: self
        @dropright.options
      end

      def_pad :context_menu!, true do
        @context ||= orphan!.new_pad ContextLayer, master: self
        @context.options
      end

      def_pad :scroll_dropdown!, true do
        @scroll_dropdown ||= orphan!.new_pad ScrollDropdownLayer, master: self
        @scroll_dropdown.options
      end

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