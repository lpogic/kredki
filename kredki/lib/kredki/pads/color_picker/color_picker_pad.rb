module Kredki
  module Pads
    class ColorPickerPad < RectanglePad

      RAINBOW_GRADIENT = [
        [0, Color::CHANNEL_MAX, 0], 
        [Color::CHANNEL_MAX, Color::CHANNEL_MAX, 0], 
        [Color::CHANNEL_MAX, 0, 0], 
        [Color::CHANNEL_MAX, 0, Color::CHANNEL_MAX], 
        [0, 0, Color::CHANNEL_MAX], 
        [0, Color::CHANNEL_MAX, Color::CHANNEL_MAX], 
        [0, Color::CHANNEL_MAX, 0],
      ]

      # :section: LEVEL 2

      def sketch
        set size_y: Fit
        set layout: :ycc, layout_spacer: 0

        cursor = proc do |d2|
          put RectanglePad, :cursor, layoutic: false, mousy: false, size: [6, 20], y: 0, fill: :black do
            set_area do
              jump 0, 0
              line 1/2r, 1/3r
              line 1r, 0

              jump 0, 1r
              line 1/2r, 2/3r
              line 1r, 1r
            end
          end
        end

        put RectanglePad, :hue, size_x: 1r, size_y: 20 do
          set &cursor
          set_fill LinearGradient.new RAINBOW_GRADIENT, lower_pad.area_size_x
          Event.each on_mouse_move, on_mouse_press do |e|
            if Kredki.mouse.pressed? :primary
              x, y = pane.translate *e.xy, self
              lower(ColorPickerPad).set_hue x / area_size_x.to_f
              find(:cursor).x = x.clamp(0..area_size_x) - 3
            end
          end
        end

        put RectanglePad, :saturation, size_x: 1r, size_y: 50 do
          set_fill LinearGradient.new [
            [Color::CHANNEL_MAX, Color::CHANNEL_MAX, Color::CHANNEL_MAX], 
            [0, 0, 0],
          ], 0, 50

          put RectanglePad, :color, size: 1r, mousy: false
          
          Event.each on_mouse_move, on_mouse_press do |e|
            if Kredki.mouse.pressed? :primary
              x, y = pane.translate *e.xy, self
              x = x.clamp(0..area_size_x)
              y = y.clamp(0..area_size_y)
              lower(ColorPickerPad).set_saturation x / area_size_x.to_f, y / area_size_y.to_f
              find(:cursor).set_xy x - 8, y - 8
            end
          end
          
          put RectanglePad, :cursor, layoutic: false, mousy: false, size: 16, fill: :black do
            set_area do
              jump 1/4r, 0
              line 0, 1/4r
              line 2/5r, 2/5r

              jump 3/4r, 0
              line 1r, 1/4r
              line 3/5r, 2/5r

              jump 0, 3/4r
              line 1/4r, 1r
              line 2/5r, 3/5r

              jump 1r, 3/4r
              line 3/4r, 1r
              line 3/5r, 3/5r
            end
          end
        end

        put RectanglePad, :opacity, size_x: 1r, size_y: 20 do
          set_fill :white
          put RectanglePad, size: 1r, mousy: false do
            set_area do |sx, sy|
              rx = (sx + 16) / 16
              ry = (sy + 8) / 8
              rx.times do |i|
                ry.times do |j|
                  jump i * 16 + (j % 2 == 0 ? 4 : 12), j * 8 + 4
                  rectangle 8, 8
                end
              end
            end
          end
          put RectanglePad, :color, size: 1r, mousy: false
          set &cursor
          Event.each on_mouse_move, on_mouse_press do |e|
            if Kredki.mouse.pressed? :primary
              x, y = pane.translate *e.xy, self
              lower(ColorPickerPad).set_opacity x / area_size_x.to_f
              find(:cursor).x = x.clamp(0..area_size_x) - 3
            end
          end
        end
        
        @hue = 0.5
        @saturation = [0.5, 0.5]
        @opacity = 0.5
        set_hue 0.5
      end

      def set_hue value, update_note: true
        @hue = value
        @hue_color = case value
        when 0..1/6r
          red = Color::CHANNEL_MAX * value * 6
          [red, Color::CHANNEL_MAX, 0]
        when 1/6r..2/6r
          green = Color::CHANNEL_MAX * (value - 2/6r) * -6
          [Color::CHANNEL_MAX, green, 0]
        when 2/6r..3/6r
          blue = Color::CHANNEL_MAX * (value - 2/6r) * 6
          [Color::CHANNEL_MAX, 0, blue]
        when 3/6r..4/6r
          red = Color::CHANNEL_MAX * (value - 4/6r) * -6
          [red, 0, Color::CHANNEL_MAX]
        when 4/6r..5/6r
          green = Color::CHANNEL_MAX * (value - 4/6r) * 6
          [0, green, Color::CHANNEL_MAX]
        when 5/6r..1
          blue = Color::CHANNEL_MAX * (value - 1) * -6
          [0, Color::CHANNEL_MAX, blue]
        else
          [0, Color::CHANNEL_MAX, 0]
        end
        find(A + :hue + :cursor).fill = @hue_color[1] < Color::CHANNEL_MAX * 0.5 ? :white : :black
        find(A + :saturation + :color).fill = LinearGradient.new [[*@hue_color, 0], @hue_color], area_size_x
        set_saturation *@saturation, update_note: update_note
      end

      def set_saturation x, y, update_note: true
        @saturation = [x, y]
        shade = case y
        when ..0
          Color::CHANNEL_MAX
        when 0...1
          Color::CHANNEL_MAX * (1 - y)
        else
          0
        end
        @saturation_color = @hue_color.map{|it| shade * (1 - x) + it * x }
        find(A + :saturation + :cursor).fill = @saturation_color[1] < Color::CHANNEL_MAX * 0.5 ? :white : :black
        find(A + :opacity + :color).fill = LinearGradient.new [[*@saturation_color, 0], @saturation_color, @saturation_color], area_size_x
        set_opacity @opacity, update_note: update_note
      end

      def set_opacity value, update_note: true
        @opacity = value
        @opacity_color = case value
        when ..0
          [*@saturation_color, 0]
        when ..0.5
          [*@saturation_color, Color::CHANNEL_MAX * 2 * value]
        else
          @saturation_color
        end
        light_cursor = @opacity_color[1] < Color::CHANNEL_MAX * 0.5 && 
          (!@opacity_color[3] || @opacity_color[3] > Color::CHANNEL_MAX * 0.65)
        find(A + :opacity + :cursor).fill = light_cursor ? :white : :black
        color = Kredki.color @opacity_color
        color = color.clarify 1 if color.a == 0
        lower(ColorPicker)&.find(A + Button + :color)&.fill = color

        if update_note
          text = @opacity_color.map{|it| it.to_i.to_s(16).rjust 2, "0" }.join.upcase.then{|it| "##{it}" }
          lower(ColorPicker)&.find(Note)&.text = text
        end
      end

      def set_color color, update_note: true
        color = color.to_rgba.map{|it| it * 1.0 / Color::CHANNEL_MAX }
        sc = color[0..2].each_with_index.to_a.sort
        if sc.last[0] < 1.0
          y = (1 - sc.last[0]) / (sc.first[0] - sc.last[0] + 1)
        else
          y = 0
        end
        if y < 1.0
          x = sc.first[0] / (1 - y)
        else
          x = 1.0
        end
        if x < 1
          z = (sc[1][0] - x + x * y) / (1 - x)
        else
          z = 0
        end

        @opacity = color[3] < 1 ? color[3] / 2 : 0.75
        opacity_pad = find :opacity
        opacity_pad[:cursor].x = @opacity * opacity_pad.area_size_x - 3
        
        @saturation = [x, y]
        saturation_pad = find :saturation
        saturation_pad[:cursor].set_xy x * saturation_pad.area_size_x - 8, y * saturation_pad.area_size_y - 8

        @hue = case sc.map{|it| it[1] }
        when [2, 1, 0]
          2/6r - z / 6
        when [1, 2, 0]
          2/6r + z / 6
        when [1, 0, 2]
          4/6r - z / 6
        when [0, 1, 2]
          4/6r + z / 6
        when [0, 2, 1]
          1 - z / 6
        else
          z / 6
        end.to_f

        hue_pad = find :hue
        hue_pad[:cursor].x = @hue * hue_pad.area_size_x - 3

        set_hue @hue, update_note: update_note
      end

      def update_size x, y
        if super
          hue = find :hue
          hue.fill = LinearGradient.new RAINBOW_GRADIENT, hue.lower_pad.area_size_x
          set_hue @hue, update_note: false
          true
        end
      end


    end#ColorPickerPad
  end#Pads
end#Kredki
