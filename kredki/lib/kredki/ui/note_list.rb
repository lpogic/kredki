require 'forwardable'
require_relative 'option/scroll_dropdown_layer'
require_relative 'theme'

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

      def option! ...
        scroll_dropdown!.option!(...)
      end

      #internal api

      def initialize
        super

        @picked = nil
      end

      attr :picked


      def sketch p0
        super
  
        scroll_dropdown!
  
        on_focus_lose! do
          string! "" if !@picked
        end
  
        on_edit!{ @picked = nil }

        on! Option::PickEvent do |e|
          s = e.target.string
          @picked = s
          string! s, :end
        end
    
        # on_click! do |e|
        #   @options.load! unless @options.show?
        #   e.resolve
        # end

        # on_mouse_button! :scroll do |e|
        #   if @options.show?
        #     @options.detach!
        #     e.resolve
        #   end
        # end
  
        # on_key! :down, :up do |e|
        #   unless @options.show?
        #     @options.load!
        #     e.resolve
        #   end
        # end
      end
    end
  end
end