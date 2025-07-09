require_relative '../kredki'

class Symbol
  def <=>(oth)
    0 if Numeric === oth
  end
end

module Kredki

  PS = POSITION_START = proc{ 0 }
  PC = POSITION_CENTER = proc{ (_1 - _2) / 2 }
  PE = POSITION_END = proc{ _1 - _2 }
  PCS = POSITION_CENTER_START = proc{|a, b| a > b ? POSITION_CENTER[a, b] : POSITION_START[a, b] }
  PCE = POSITION_CENTER_END = proc{|a, b| a > b ? POSITION_CENTER[a, b] : POSITION_END[a, b] }

  module UI
    class << self
      attr_accessor :layouts

      def eqr a, b
        a == b and (Rational === a) == (Rational === b)
      end
  
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
  require_relative 'ui/text_pad'
  require_relative 'ui/text/navigable_text'
  require_relative 'ui/grid/grid_pad'
  require_relative 'ui/note'
  require_relative 'ui/notes'
  require_relative 'ui/button'
  require_relative 'ui/checkbox'
  require_relative 'ui/radiobox'
  require_relative 'ui/label'
  require_relative 'ui/note_dropdown/note_dropdown'
  require_relative 'ui/table'

  require_relative "ui/layout/basic"
  require_relative "ui/layout/x_layout"
  require_relative "ui/layout/y_layout"
  require_relative "ui/option/option"
  require_relative 'ui/option/dropdown_layer'
  require_relative 'ui/option/dropright_layer'
  require_relative 'ui/option/context_layer'

  UI.layouts = {
    nil => UI::Layout::Basic.new(0, 0),
    start: UI::Layout::Basic.new(PS, PS),
    center: UI::Layout::Basic.new(PC, PC),
    end: UI::Layout::Basic.new(PE, PE),
    column: UI::Layout::YLayout.new(0, 0),
    row: UI::Layout::XLayout.new(0, 0),
    %i|start start| => UI::Layout::Basic.new(PS, PS),
    %i|start center| => UI::Layout::Basic.new(PS, PC),
    %i|start end| => UI::Layout::Basic.new(PS, PE),
    %i|center start| => UI::Layout::Basic.new(PC, PS),
    %i|center center| => UI::Layout::Basic.new(PC, PC),
    %i|center end| => UI::Layout::Basic.new(PC, PE),
    %i|end start| => UI::Layout::Basic.new(PE, PS),
    %i|end center| => UI::Layout::Basic.new(PE, PC),
    %i|end end| => UI::Layout::Basic.new(PE, PE),
    %i|column start| => UI::Layout::YLayout.new(PS, 0),
    %i|column center| => UI::Layout::YLayout.new(PC, 0),
    %i|column end| => UI::Layout::YLayout.new(PE, 0),
    %i|column start start| => UI::Layout::YLayout.new(PS, PS),
    %i|column start center| => UI::Layout::YLayout.new(PS, PC),
    %i|column start end| => UI::Layout::YLayout.new(PS, PE),
    %i|column center start| => UI::Layout::YLayout.new(PC, PS),
    %i|column center center| => UI::Layout::YLayout.new(PC, PC),
    %i|column center end| => UI::Layout::YLayout.new(PC, PE),
    %i|column end start| => UI::Layout::YLayout.new(PE, PS),
    %i|column end center| => UI::Layout::YLayout.new(PE, PC),
    %i|column end end| => UI::Layout::YLayout.new(PE, PE),
    %i|row start| => UI::Layout::XLayout.new(PS, 0),
    %i|row center| => UI::Layout::XLayout.new(PC, 0),
    %i|row end| => UI::Layout::XLayout.new(PE, 0),
    %i|row start start| => UI::Layout::XLayout.new(PS, PS),
    %i|row start center| => UI::Layout::XLayout.new(PS, PC),
    %i|row start end| => UI::Layout::XLayout.new(PS, PE),
    %i|row center start| => UI::Layout::XLayout.new(PC, PS),
    %i|row center center| => UI::Layout::XLayout.new(PC, PC),
    %i|row center end| => UI::Layout::XLayout.new(PC, PE),
    %i|row end start| => UI::Layout::XLayout.new(PE, PS),
    %i|row end center| => UI::Layout::XLayout.new(PE, PC),
    %i|row end end| => UI::Layout::XLayout.new(PE, PE),
    s: UI::Layout::Basic.new(PS, PS),
    c: UI::Layout::Basic.new(PC, PC),
    e: UI::Layout::Basic.new(PE, PE),
    v: UI::Layout::YLayout.new(0, 0),
    h: UI::Layout::XLayout.new(0, 0),
    ss: UI::Layout::Basic.new(PS, PS),
    sc: UI::Layout::Basic.new(PS, PC),
    se: UI::Layout::Basic.new(PS, PE),
    cs: UI::Layout::Basic.new(PC, PS),
    cc: UI::Layout::Basic.new(PC, PC),
    ce: UI::Layout::Basic.new(PC, PE),
    es: UI::Layout::Basic.new(PE, PS),
    ec: UI::Layout::Basic.new(PE, PC),
    ee: UI::Layout::Basic.new(PE, PE),
    vs: UI::Layout::YLayout.new(PS, 0),
    vc: UI::Layout::YLayout.new(PC, 0),
    ve: UI::Layout::YLayout.new(PE, 0),
    vss: UI::Layout::YLayout.new(PS, PS),
    vsc: UI::Layout::YLayout.new(PS, PC),
    vse: UI::Layout::YLayout.new(PS, PE),
    vcs: UI::Layout::YLayout.new(PC, PS),
    vcc: UI::Layout::YLayout.new(PC, PC),
    vce: UI::Layout::YLayout.new(PC, PE),
    ves: UI::Layout::YLayout.new(PE, PS),
    vec: UI::Layout::YLayout.new(PE, PC),
    vee: UI::Layout::YLayout.new(PE, PE),
    hs: UI::Layout::XLayout.new(0, PS),
    hc: UI::Layout::XLayout.new(0, PC),
    he: UI::Layout::XLayout.new(0, PE),
    hss: UI::Layout::XLayout.new(PS, PS),
    hsc: UI::Layout::XLayout.new(PS, PC),
    hse: UI::Layout::XLayout.new(PS, PE),
    hcs: UI::Layout::XLayout.new(PC, PS),
    hcc: UI::Layout::XLayout.new(PC, PC),
    hce: UI::Layout::XLayout.new(PC, PE),
    hes: UI::Layout::XLayout.new(PE, PS),
    hec: UI::Layout::XLayout.new(PE, PC),
    hee: UI::Layout::XLayout.new(PE, PE),
    x: UI::Layout::XLayout.new(0, 0),
    xc: UI::Layout::XLayout.new(PC, PC),
    y: UI::Layout::YLayout.new(0, 0),
    yc: UI::Layout::YLayout.new(PC, PC),
  }

  module UI
    module PadBase
      def! :pad!, Pad
      def! :space!, SpacePad
      def! :grid!, GridPad
      def! :scroll!, ScrollPad
      def! :image!, ImagePad
      def! :text!, NavigableText, keyboardy: true
      def! :xslide!, HorizontalSlide
      def! :yslide!, VerticalSlide
      def! :button!, ButtonPad
      def! :check!, Checkbox
      def! :radio!, Radiobox
      def! :note!, Note
      def! :notes!, Notes
      def! :label!, Label
      def! :note_dropdown!, NoteDropdown
      def! :table!, Table

      def! :radio_group!, RadioGroup
      def! :option_group!, OptionGroup

      def! :option!, Option

      def! :context_menu!, true do
        @context_menu ||= new ContextLayer
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