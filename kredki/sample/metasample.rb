require 'kredki'

# Sample to run samples.

window.wh! 800, 400

define :list_action do
  layout! :yss

  pad! layout: :xcc, fill: [10, 50, 10], m: 8, h: Fit, w: 1r do
    put! "Click #{ glyph! :media_play, fill: :text } to run the sample or #{ text! "double-click", fill: :yellow } on a line to view the code."
  end

  scroll! wh: 1r, layout: :zss do
    list! w: 1r, h: Fit, fill: :transparent do

      go_sample = proc do |sample|
        window.shift{ sample_code_action File.expand_path "#{Kredki.dir}/sample/#{sample}" }
      end

      Dir["*.rb"].each_with_index do |file, index| 
        item! "#{index + 1}. #{file}", subject: file, suit: [20, 70, 20], m: [xs: 3, i: 5] do
          glyph! :media_play, fill: :text, show: false, mouse_cursor: :pointer do
            on_mouse_enter{ mag! 1.2 }
            on_mouse_leave{ mag! 1.0 }
            on_mouse_click{ run_sample_action file, File.read(File.expand_path "#{Kredki.dir}/sample/#{file}") }
          end
          on_mouse_enter{ d?(:glyph!).show! }
          on_mouse_leave{ d?(:glyph!).hide! }
          on_mouse_click{ go_sample.call subject if layer.mouse_clicks == 2 }
          on_key_press :enter do
            go_sample.call subject
          end
        end
      end

    end
  end

  d?(Item).keyboard_request
end

define :sample_code_action do |file|
  layout! :yss

  n = notes! File.read(file), verse: [font: :martian_mono, size: 14], wh: 1r, 
    suit: [20, 70, 20]
  xec! w: 1r, h: Fit, mi: 10, m: 10 do
    button! "Back", on_click: proc{ window.shift{ list_action } }
    button! "Run", suit: :orange do
      on_click{ run_sample_action file, "#{n.content}" }
    end
  end
end

define :run_sample_action do |file, code|
  app.open :wh_drag!, :close_on_esc!, title: file do
    begin
      eval code
    rescue Exception => e
      window.shift do
        fill! :red
        text! "#{e.class}"
      end
    end
  end
end

window.shift{ list_action }