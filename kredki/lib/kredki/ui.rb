require_relative 'core'

module Kredki
  module UI
    class << self
      attr_accessor :layout_map

      def init
        @layout_map = {}
      end

      def eqr a, b
        a == b and (Rational === a) == (Rational === b)
      end
  
      def layout param = nil
        case param
        in Layout::Basic
          param
        else
          @layout_map[param] or raise "Unknown layout '#{param}'"
        end
      end
    end

    self.layout_map = {}
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
  require_relative 'ui/list/tree_list'
  require_relative 'ui/context_menu/context_menu'
  require_relative 'ui/toolbar_menu/toolbar_menu'

  require_relative "ui/layout/basic"
  require_relative "ui/layout/xway"
  require_relative "ui/layout/yway"

  module UI
    begin
      layout_map[nil] = Layout::Basic.new :center, :center
      layout_map[:center] = Layout::Basic.new :center, :center
      layout_map[:x] = Layout::Xway.new :center, :center
      layout_map[:y] = Layout::Yway.new :center, :center
      
      [:begin, :center, :end].repeated_permutation 2 do
        layout_map["#{it[0]}_#{it[1]}".to_sym] = Layout::Basic.new it[0], it[1]
        layout_map["x_#{it[0]}_#{it[1]}".to_sym] = Layout::Xway.new it[0], it[1]
        layout_map["y_#{it[0]}_#{it[1]}".to_sym] = Layout::Yway.new it[0], it[1]
      end
    end

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
      def! :note_items!, NoteDropdown
      def! :table!, Table
      def! :list!, List
      def! :tree_list!, TreeList

      def! :radios!, RadioGroup

      def! :context_menu!, ContextMenu
      def! :toolbar_menu!, ToolbarMenu

    end#PadBase
  end#UI

  Window.default_action = UI::Action
end#Kredki

class CarryFocusOnTab
  def self.plug_into target
    target.on_key_down! :tab do |event|
      next_pad = target.layer.keyboard_pad&.then do |p0|
        target.each_pad(reverse: event.shift?, deep: true)
          .lazy
          .drop_while{|p1| p0 != p1 }
          .drop(1)
          .filter{ it.keyboardy? && it.show? }
          .first
      end || target.each_pad(reverse: event.shift?, deep: true)
        .lazy
        .filter{ it.keyboardy? && it.show? }
        .first
      next_pad.keyboard_request if next_pad
    end
  end
end