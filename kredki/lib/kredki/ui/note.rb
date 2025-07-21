require_relative 'text/editable_text_verse'
require_relative 'theme'

module Kredki
  module UI
    class Note < Pad
      include TextEdition
      extend Forwardable
      extend HasParams

      class SimpleColorBasedTheme < Theme
        model :color

        def attach! pad
          super pad,
            pad.on_focus_enter!,
            pad.on_focus_leave!,
            pad.on_mouse_enter!,
            pad.on_mouse_leave!
        end

        def repaint
          kb_top = @pad.keyboard_top?
          @pad.area.fill_color = kb_top ? @color.darken : @pad.mouse_in? ? @color.lighten : @color
          @pad.area.stroke_color = kb_top ? :stroke_focus : @color
          @pad.text.selection.each{ it.fill_color! kb_top ? :text_selection : :text_selection_inactive }
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

      def << arg
        case arg
        when String
          content! arg
        else
          super
        end
      end

      param_service def cursor
        @text.cursor
      end

      param def content! string, cursor = false
        @text.content! string, cursor
      end, def string
        @text.content
      end

      param_prefix :verse

      param_delegate :@text,
      :verse_size,
      :verse_layout

      #internal api

      class NoteLayout < Layout::Basic
        def arrange pad
          cw = pad.cw
          ch = pad.ch

          lx = lw = ly = lh = 0

          pad.arrange_pads.each do |p1|
            pw = get_w p1, p1.w, cw
            ph = get_h p1, p1.h, ch
            p1.set_size pw, ph
            p1.arrange
            px = p1.get_x cw, pw, (get_c @x, cw, pw)
            py = p1.get_y ch, ph, (get_c @y, ch, ph)
            p1.set_xy px, py
            p1.set_margin
            if p1.in_layout?
              lx = [lx, px].min
              ly = [ly, py].min
              lw = [lw, pw].max
              lh = [lh, ph].max
            end
          end

          [lx, ly, lw, lh]
        end
      end

      attr :text

      def initialize
        super
      
        initialize_text
        @theme = nil
      end

      def initialize_text
        @text = new EditableTextVerse, wh: 100r, mousy: false
      end

      def sketch p0
        super

        layout! NoteLayout.new(0, 0)
        mousy!
        keyboardy!
        stroke_size! 1
        theme! :gray
        h! 24

        sketch_text
      end

      def sketch_text
        text_edition @text, false
      end
    end
  end
end