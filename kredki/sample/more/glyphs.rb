require 'kredki'

# Utility for searching defined glyphs.
# Returns clicked glyph id.

module Presets
  def self.glyph glyph
    Preset.new glyph do

      on_mouse_enter do
        self.zoom = 1.2
        psx, psy = pane.area_size
        gsx, gsy = area_size
        gx, gy = translate
        pane.layer! :glyph_layer do
          pad! size: Fit, fill: :gray, corner: 4, stroke: [1, :dark_gray], margin: 4 do
            text! ":#{glyph}"
          end
          arrange # to determine pad area size
          self[:pad!] do
            sx, sy = it.area_size
            x = gx + gsx / 2 - sx / 2
            if x < 0
              x = 0
            elsif x + sx > psx
              x = psx - sx
            end

            y = gy + gsy + 4
            if y + sy > psy
              y = gy - sy - 4
            end

            it.set_xy x, y
          end
        end
      end

      on_mouse_leave do
        self.zoom = 1.0
        pane[:glyph_layer].detach
      end

      on_mouse_click do
        application.return glyph
      end

    end
  end
end

set_layout :yss

table! size: 1r do
	5.times{ column! 1r }
  
  scroll_rows! do
    glyphs = Kredki.glyphs.keys.each
	  begin
			loop do
        row! do
          5.times do
            cell! margin: [y: 6, clip: false] do
              glyph! Presets.glyph(glyphs.next), size: 30, mouse_cursor: :pointer
            end
          end
        end
			end
    rescue StopIteration
		end
	end
end
