require 'kredki'

# Sample to run samples.

window.wh! 800, 400
window.title! "Metasample"

define :list do
  layout! :yss

  space! layout: :xcc, m: 8, h: :fit do
    text! "Click "
    glyph! :media_play, fill: :text
    text! " to run the example or double-click on a line to view the code."
  end

  scroll! wh: 1r, layout: :zss do
    list! w: 1r, h: :fit, fill: :transparent do

      go_sample = proc do |sample|
        window.shift{ sample File.expand_path "#{Kredki.dir}/sample/#{sample}" }
      end

      Dir["*.rb"].each_with_index do |file, index| 
        item! "#{index + 1}. #{file}", subject: file, suit: Kredki.color([20, 70, 20]), mi: 5 do
          glyph! :media_play, fill: :text, show: false, mouse_cursor: :pointer do
            on_mouse_enter{ mag! 1.2 }
            on_mouse_leave{ mag! 1.0 }
            on_mouse_click{ run_sample File.read File.expand_path "#{Kredki.dir}/sample/#{file}" }
          end
          on_mouse_enter{ fd(:glyph!).show! }
          on_mouse_leave{ fd(:glyph!).hide! }
          on_mouse_click{ go_sample.call subject if layer.mouse_clicks == 2 }
          on_key_press :enter do
            go_sample.call subject
          end
        end
      end

    end
  end

  fd(Item).keyboard_request
end

define :sample do |file|
  layout! :yss

  n = notes! File.read(file), verse: [font: :martian_mono, size: 14], wh: 1r, 
    suit: Kredki.color([20, 70, 20])
  space! w: 1r, h: :fit, layout: :xec, mi: 10, m: 10 do
    button! "Back", on_click: proc{ window.shift{ list } }
    button! "Run", suit: :orange do
      on_click{ run_sample "#{n}" }
    end
  end
end

define :run_sample do |code|
  application.window! do 
    window.wh_drag!
    window.close_on_esc!
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

window.shift{ list }