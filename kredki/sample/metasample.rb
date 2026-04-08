require 'kredki'

# A GUI-mode sample overview.

class ListPane < Pane
  layer! do
    pane.close_on_esc
    set_layout :yss

    pad! layout: :xcc, fill: [10, 50, 10], margin: 8, size_y: Fit, size_x: 1r do
      set "Click #{ glyph! :media_play, fill: :text } to run the sample or #{ text! "double-click", fill: :yellow } on a line to view the code."
    end

    scroll! size: 1r, layout: :zss do
      list! size_x: 1r, size_y: Fit, fill: false do

        go_sample = proc do |sample|
          window.set SampleCodePane.new(File.expand_path("#{Kredki.dir}/sample/#{sample}"), pane)
        end

        Dir["*.rb"].each_with_index do |file, index| 
          item! "#{index + 1}. #{file}", subject: file, suit: [20, 70, 20], spacer: 5 do
            glyph! :media_play, fill: :text, scenic: false, mouse_cursor: :pointer do
              on_mouse_enter{ set_zoom 1.2 }
              on_mouse_leave{ set_zoom 1.0 }
              on_mouse_click{ app.open RunSamplePane.new(file, File.read(File.expand_path "#{Kredki.dir}/sample/#{file}")) }
            end
            on_mouse_enter{ glyph?.set_scenic true }
            on_mouse_leave{ glyph?.set_scenic false }
            on_mouse_click{|event| go_sample.call subject if event.combo == 2 }
          end
        end

      end
    end
  end
end


class SampleCodePane < Pane
  layer! do |file, list_pane|
    pane.close_on_esc
    set_layout :yss

    notes! File.read(file), verse: [font: :martian_mono, size: 14], size: 1r, suit: [20, 70, 20]
    xec! size_x: 1r, size_y: Fit, spacer: 10, margin: 10 do
      button! "Back", on_click: proc{ window.set list_pane }
      button! "Run", suit: :orange do
        on_click{ app.open RunSamplePane.new(file, pane.notes?.text) }
      end
    end
  end
end

class RunSamplePane < Pane
  layer! do |file, code|
    window.set resizable: true, title: file
    pane.close_on_esc

    begin
      eval code
    rescue Exception => e
      window.pane! do
        set_fill :red
        set_layout :ycc
        text! "#{e.class}"
        message = e.message.split(" ").each_slice(5).map{|it| it.join " " }.join("\n") 
        text! message, verse: [16, layout: :ycc]
      end
    end
  end
end

window.set ListPane.new, size: [800, 400]