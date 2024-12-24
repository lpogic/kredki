require 'forwardable'
require_relative 'option/scroll_options_layer'

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
            pad.editor.color! @picked ? :white : Kredki.color(:white).dark(70)
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

      def option! *a, **na, &b
        @options.option! *a, w: w, **na, &b
      end

      #internal api

      def initialize
        super

        @options = nil
        @picked = nil
      end


      def sketch p0
        super
  
        @options = orphan!.new_pad ScrollOptionsLayer do
          autodetach! false

          on_key! :escape do |e|
            detach!
            e.resolve
          end
        end
          
        on_focus_gain! do |e|
          @options.attach! action, *translate(0, h), w
        end
  
        on_focus_lose! do
          @options.detach!
          string! "" if !@picked
        end
  
        on_edit! do
          @picked = nil
          repaint
        end
    
        on_click! do |e|
          @options.attach! action, *translate(0, h), w unless @options.show?
          e.resolve
        end

        on_mouse_button! :scroll do |e|
          if @options.show?
            @options.detach!
            e.resolve
          end
        end
  
        on_key! :down, :up do |e|
          unless @options.show?
            @options.attach! action, *translate(0, h), w
            e.resolve
          end
        end

        @options.on! Option::PickEvent do |e|
          s = e.target.string
          @picked = s
          string! s, :end
          @options.detach!
          repaint
        end
      end
    end
  end
end