require_relative '../kredki'

module Kredki

  PS = POSITION_START = proc{ 0 }
  PC = POSITION_CENTER = proc{ (_1 - _2) / 2 }
  PE = POSITION_END = proc{ _1 - _2 }
  PCS = POSITION_CENTER_START = proc{|a, b| a > b ? POSITION_CENTER[a, b] : POSITION_START[a, b] }
  PCE = POSITION_CENTER_END = proc{|a, b| a > b ? POSITION_CENTER[a, b] : POSITION_END[a, b] }

  module UI
    class << self
      attr_accessor :layouts
  
      def layout param = nil
        case param
        in Layout::Basic
          param
        else
          @layouts[param] or raise "Unknown layout '#{param}'"
        end
      end
    end
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
  require_relative 'ui/note'
  require_relative 'ui/notes'
  require_relative 'ui/button'
  require_relative 'ui/note_dropdown/note_dropdown'

  require_relative "ui/layout/basic"
  require_relative "ui/layout/row"
  require_relative "ui/layout/column"
  require_relative "ui/option/option"
  require_relative 'ui/option/dropdown_layer'
  require_relative 'ui/option/dropright_layer'
  require_relative 'ui/option/context_layer'

  UI.layouts = {
    nil => UI::Layout::Basic.new(0, 0),
    start: UI::Layout::Basic.new(PS, PS),
    center: UI::Layout::Basic.new(PC, PC),
    end: UI::Layout::Basic.new(PE, PE),
    column: UI::Layout::Column.new(0, 0),
    row: UI::Layout::Row.new(0, 0),
    %i|start start| => UI::Layout::Basic.new(PS, PS),
    %i|start center| => UI::Layout::Basic.new(PS, PC),
    %i|start end| => UI::Layout::Basic.new(PS, PE),
    %i|center start| => UI::Layout::Basic.new(PC, PS),
    %i|center center| => UI::Layout::Basic.new(PC, PC),
    %i|center end| => UI::Layout::Basic.new(PC, PE),
    %i|end start| => UI::Layout::Basic.new(PE, PS),
    %i|end center| => UI::Layout::Basic.new(PE, PC),
    %i|end end| => UI::Layout::Basic.new(PE, PE),
    %i|column start| => UI::Layout::Column.new(PS, 0),
    %i|column center| => UI::Layout::Column.new(PC, 0),
    %i|column end| => UI::Layout::Column.new(PE, 0),
    %i|column start start| => UI::Layout::Column.new(PS, PS),
    %i|column start center| => UI::Layout::Column.new(PS, PC),
    %i|column start end| => UI::Layout::Column.new(PS, PE),
    %i|column center start| => UI::Layout::Column.new(PC, PS),
    %i|column center center| => UI::Layout::Column.new(PC, PC),
    %i|column center end| => UI::Layout::Column.new(PC, PE),
    %i|column end start| => UI::Layout::Column.new(PE, PS),
    %i|column end center| => UI::Layout::Column.new(PE, PC),
    %i|column end end| => UI::Layout::Column.new(PE, PE),
    %i|row start| => UI::Layout::Row.new(PS, 0),
    %i|row center| => UI::Layout::Row.new(PC, 0),
    %i|row end| => UI::Layout::Row.new(PE, 0),
    %i|row start start| => UI::Layout::Row.new(PS, PS),
    %i|row start center| => UI::Layout::Row.new(PS, PC),
    %i|row start end| => UI::Layout::Row.new(PS, PE),
    %i|row center start| => UI::Layout::Row.new(PC, PS),
    %i|row center center| => UI::Layout::Row.new(PC, PC),
    %i|row center end| => UI::Layout::Row.new(PC, PE),
    %i|row end start| => UI::Layout::Row.new(PE, PS),
    %i|row end center| => UI::Layout::Row.new(PE, PC),
    %i|row end end| => UI::Layout::Row.new(PE, PE),
  }

  module UI
    module PadBase
      def_pad :pad!, Pad
      def_pad :space!, SpacePad
      def_pad :grid!, GridPad
      def_pad :scroll!, ScrollPad
      def_pad :image!, ImagePad
      def_pad :xslide!, HorizontalSlide
      def_pad :yslide!, VerticalSlide
      def_pad :text!, TextLine
      def_pad :texts!, TextArea
      def_pad :button!, ButtonPad
      def_pad :note!, Note
      def_pad :notes!, Notes
      def_pad :note_dropdown!, true do
        new_service NoteDropdown
      end

      def_pad :option!, Option

      class RightTriangle < Kredki::ShapeArea
        def redraw w, h
          stroke_width! 3
          draw! do
            move_to! 0, 0
            line_to! w, h / 2
            line_to! 0, h
          end
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
        @context_menu ||= new_service ContextLayer
        @context_menu.set_master self
        @context_menu
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
        target.each_pad(reverse: event.shift?, deep: true)
          .lazy
          .drop_while{|p1| p0 != p1 }
          .drop(1)
          .filter{ _1.keyboardy? }
          .first
      end || target.each_pad(reverse: event.shift?, deep: true)
        .lazy
        .filter{ _1.keyboardy? }
        .first
      next_pad.gain_keyboard if next_pad
    end
  end
end