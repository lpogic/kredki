require_relative 'core'

module Keyword
  def coerce(other)
    [self, self]
  end

  def <=> o
    0
  end

  def === o
    self == o
  end

  def / o
    Keywords.new self, o
  end
end

class Keywords
  def initialize *words
    @words = words.freeze
  end

  attr :words

  def / o
    Keywords.new *@words, o
  end

  def inspect
    to_s
  end

  def to_s
    @words.join "/"
  end

  def hash
    @words.hash
  end

  def eql? o
    Keywords === o and @words == o.words
  end
end

class Fit extend Keyword end
class Begin extend Keyword end
class Center extend Keyword end
class End extend Keyword end
class X extend Keyword end
class Y extend Keyword end

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

  require_relative "ui/layout/basic"
  require_relative "ui/layout/x_way"
  require_relative "ui/layout/y_way"
  require_relative 'ui/pad/pad'
  require_relative 'ui/pad/sort_pad'
  require_relative 'ui/pad/shape_pad'
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
  require_relative 'ui/check'
  require_relative 'ui/radio/radio_group'
  require_relative 'ui/label'
  require_relative 'ui/list_note/list_note'
  require_relative 'ui/table'
  require_relative 'ui/list/list'
  require_relative 'ui/list/tree_list'
  require_relative 'ui/context_menu/context_menu'
  require_relative 'ui/toolbar_menu/toolbar_menu'

  module UI
    begin
      layout_map[nil] = Layout::Basic.new Center, Center
      layout_map[Center] = Layout::Basic.new Center, Center
      layout_map[X] = Layout::XWay.new Center, Center
      layout_map[Y] = Layout::YWay.new Center, Center
      
      [Begin, Center, End].repeated_permutation 2 do
        layout_map[it[0]/it[1]] = Layout::Basic.new it[0], it[1]
        layout_map[X/it[0]/it[1]] = Layout::XWay.new it[0], it[1]
        layout_map[Y/it[0]/it[1]] = Layout::YWay.new it[0], it[1]
      end
    end

    module PadBase
      define :pad!, ShapePad
      define :space!, SpacePad
      define :scroll!, ScrollPad
      define :image!, ImagePad
      def text! *a, **na, &b
        new NavigableText, :text!, *a, keyboardy: true, **na, &b
      end
      define :xslide!, HorizontalSlide
      define :yslide!, VerticalSlide
      define :button!, ButtonPad
      define :check!, Check
      define :note!, Note
      define :notes!, Notes
      define :label!, Label
      define :list_note!, ListNote
      define :table!, Table
      define :list!, List
      define :tree!, TreeList

      define :radio!, RadioGroup

      define :context!, ContextMenu
      define :toolbar!, ToolbarMenu

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