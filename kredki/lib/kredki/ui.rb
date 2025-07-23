require_relative 'core'

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
  require_relative 'ui/note'
  require_relative 'ui/notes'
  require_relative 'ui/button'
  require_relative 'ui/checkbox'
  require_relative 'ui/radio_group'
  require_relative 'ui/label'
  require_relative 'ui/note_dropdown/note_dropdown'
  require_relative 'ui/table'
  require_relative 'ui/list/list'
  require_relative 'ui/context_menu/context_menu'
  require_relative 'ui/toolbar_menu/toolbar_menu'

  require_relative "ui/layout/basic"
  require_relative "ui/layout/xway"
  require_relative "ui/layout/yway"

  UI.layouts = {
    nil => UI::Layout::Basic.new(0, 0),
    center: UI::Layout::Basic.new(PC, PC),
    column: UI::Layout::Yway.new(0, 0),
    row: UI::Layout::Xway.new(0, 0),

    c: UI::Layout::Basic.new(PC, PC),
    x: UI::Layout::Xway.new(0, 0),
    xc: UI::Layout::Xway.new(PC, PC),
    xcc: UI::Layout::Xway.new(PC, PC),
    y: UI::Layout::Yway.new(0, 0),
    yc: UI::Layout::Yway.new(PC, PC),
    ycc: UI::Layout::Yway.new(PC, PC),

    bb: UI::Layout::Basic.new(0, 0),
    xbb: UI::Layout::Xway.new(0, 0),
    ybb: UI::Layout::Yway.new(0, 0),
    eb: UI::Layout::Basic.new(PE, 0),
    xeb: UI::Layout::Xway.new(PE, 0),
    yeb: UI::Layout::Yway.new(PE, 0),
    be: UI::Layout::Basic.new(0, PE),
    xbe: UI::Layout::Xway.new(0, PE),
    ybe: UI::Layout::Yway.new(0, PE),
    ee: UI::Layout::Basic.new(PE, PE),
    xee: UI::Layout::Xway.new(PE, PE),
    yee: UI::Layout::Yway.new(PE, PE),

    bc: UI::Layout::Basic.new(0, PC),
    xbc: UI::Layout::Xway.new(0, PC),
    ybc: UI::Layout::Yway.new(0, PC),
    ec: UI::Layout::Basic.new(PE, PC),
    xec: UI::Layout::Xway.new(PE, PC),
    yec: UI::Layout::Yway.new(PE, PC),
    cb: UI::Layout::Basic.new(PC, 0),
    xcb: UI::Layout::Xway.new(PC, 0),
    ycb: UI::Layout::Yway.new(PC, 0),
    ce: UI::Layout::Basic.new(PC, PE),
    xce: UI::Layout::Xway.new(PC, PE),
    yce: UI::Layout::Yway.new(PC, PE),
  }

  module UI
    module PadBase
      def! :pad!, Pad
      def! :space!, SpacePad
      def! :scroll!, ScrollPad
      def! :image!, ImagePad
      def! :text!, NavigableText, keyboardy: true
      def! :xslide!, HorizontalSlide
      def! :yslide!, VerticalSlide
      def! :button!, ButtonPad
      def! :checkbox!, Checkbox
      def! :note!, Note
      def! :notes!, Notes
      def! :label!, Label
      def! :option_note!, NoteDropdown
      def! :table!, Table
      def! :list!, List

      def! :radios!, RadioGroup
      def! :options!, OptionGroup

      def! :context_menu!, ContextMenu
      def! :toolbar_menu!, ToolbarMenu

    end#PadBase
  end#UI

  Window.default_action = UI::Action
end#Kredki

include Kredki::UI

class CarryFocusOnTab
  def self.plug_into target
    target.on_key_down! :tab do |event|
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
      next_pad.keyboard_request if next_pad
    end
  end
end