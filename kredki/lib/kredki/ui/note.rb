require_relative 'text/editable_text_verse'
require_relative 'theme'

module Kredki
  module UI
    class Note < ShapePad
      include TextEdition
      extend Forwardable
      extend HasParams

      class ColorTheme < Theme
        model :color

        def attach! pad
          super pad, [
            pad.on_focus_enter!,
            pad.on_focus_leave!,
            pad.on_mouse_enter!,
            pad.on_mouse_leave!,
          ]
        end

        def repaint
          kb_top = @pad.keyboard_top?
          @pad.area.fill_color = kb_top ? @color.darken : @pad.mouse_in? ? @color.lighten : @color
          @pad.area.stroke_color = kb_top ? :stroke_focus : @color
          @pad.verse.selection.each_paint{ it.fill_color! kb_top ? :text_selection : :text_selection_inactive }
        end
      end

      def color_theme color
        ColorTheme.new color
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
        @verse.cursor
      end

      param def content! string, cursor = false
        @verse.content! string, cursor
      end, def string
        @verse.content
      end

      param_prefix :verse

      param_delegate :@verse,
      :verse_size,
      :verse_layout

      #internal api

      class NoteLayout < Layout::XWay
        def arrange_layoutic pad, cw, ch, cx
          pw = pad.sw
          ph = pad.sh
          px = pad.get_x cw, pw, cx
          py = pad.get_y ch, ph, (get_y @y, ch, ph)
          pad.arrange
          pad.set_xy px, py
          pad.set_margin
          [pw, ph, px, py]
        end
      end

      attr :verse

      def initialize
        super
      
        initialize_verse
        @theme = nil
      end

      def initialize_verse
        @verse = new EditableTextVerse, "", wh: 1r, mousy: false
      end

      def sketch p0
        super

        layout! NoteLayout.new(Begin, Center)
        mousy!
        keyboardy!
        stroke_size! 1
        m! 1
        theme! :gray
        h! 24

        sketch_verse
      end

      def sketch_verse
        text_edition @verse, false
      end
    end
  end
end