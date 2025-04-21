require 'forwardable'
require_relative 'note_list_dropdown_layer'
require_relative '../theme'

module Kredki
  module UI
    class NoteList < Note
      extend Forwardable

      class SimpleColorBasedTheme < Theme
        model :color

        def attach! pad
          super pad,
            pad.on_focus_gain!,
            pad.on_focus_lose!,
            pad.on_mouse_enter!,
            pad.on_mouse_leave!,
            pad.on_edit!,
            pad.on!(Option::PickEvent)
        end

        def repaint
          @pad.area.color = @pad.mouse_in? ? @color.lighten : @color
          @pad.area.stroke_color = @pad.keyboard_in? ? Kredki.color(:yellow) : @color
          @pad.editor.text.color = @pad.picked.nil? ? Kredki.color(:white).darken(70) : :white
        end
      end
      
      def color_theme color
        SimpleColorBasedTheme.new color
      end

      param def theme! theme
        theme = case theme
        when Theme
          theme
        when Symbol, Array
          color_theme Kredki.color theme
        else raise_ia theme 
        end
        @theme != theme && begin
          @theme = theme
          theme.attach! self
        end
      end

      def dropdown! ...
        @dropdown ||= orphan!.new_pad(NoteListDropdownLayer).alter(...).alter master: self
        @dropdown.options
      end

      def option! ...
        dropdown!.option!(...)
      end

      #internal api

      class Context
        extend Forwardable

        model :origin do |m|
          @options = @origin.dropdown!
        end

        def note! &block
          @origin.instance_exec &block
        end

        # def_delegators :@self, *NoteList.public_instance_methods
        # p PabBase.public_instance_methods
        # def_delegators :@options, *PadBase.public_instance_methods

        def method_missing name, *a, **na, &b
          target = name.end_with?("!") ? @origin.dropdown! : @origin
          target.send name, *a, **na, &b
        end
      end

      def alter_block_context
        Context.new self
      end

      def initialize
        super

        @picked = nil
      end

      attr :picked


      def sketch p0
        super
  
        on_focus_lose! do
          string! "" if !@picked
        end
  
        on_edit!{ @picked = nil }

        on! Option::PickEvent do |e|
          s = e.target.string
          @picked = s
          string! s, :end
        end
      end
    end
  end
end