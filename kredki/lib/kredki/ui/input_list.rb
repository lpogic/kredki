require 'forwardable'
require_relative 'option/scroll_dropdown_layer'

module Kredki
  module UI
    class InputList < Input
      extend Forwardable

      module Theme
      end

      class ColorBasedTheme
        include Theme
        model :@R_base_color, :@N_proc

        def to_proc
          color = @base_color
          @proc ||= proc do
            area.color = mouse_in? ? color.light : color
            area.stroke_color = keyboard_in? ? Kredki.color(:yellow) : color
            @editor.text.color! @picked ? :white : Kredki.color(:white).dark(70)
          end
        end
      end

      aliasing def theme! theme
        theme = case theme
        when Proc, Theme
          theme
        when Symbol, Array
          ColorBasedTheme.new Kredki.color theme
        else raise_ia theme 
        end
        @theme != theme && begin
          @theme = theme
          repaint
        end
      end, :theme=

      def theme
        @theme
      end

      #internal api

      def initialize
        super

        @picked = nil
      end


      def sketch p0
        super
  
        scroll_dropdown!
  
        on_focus_lose! do
          string! "" if !@picked
        end
  
        on_edit! do
          @picked = nil
          repaint
        end

        on! Option::PickEvent do |e|
          s = e.target.string
          @picked = s
          string! s, :end
          repaint
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