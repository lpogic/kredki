require 'kredki'

window.wh! 800, 400
window.title! "Metasample"

define :list do
  scroll! wh: 1r, layout: :zss do
    list! w: 1r, h: :fit, fill: :transparent do
      Dir["*.rb"].each_with_index do |file, index| 
        item! "#{index + 1}. #{file}", subject: file, suit: Kredki.color([20, 70, 20])
      end

      go_sample = proc do |e|
        smpl = File.expand_path "#{Kredki.dir}/sample/#{e.target.subject}"
        window.shift{ sample File.read smpl }
      end

      on_mouse_click do |e|
        go_sample[e] if layer.mouse_clicks == 2
      end

      on_key_press :enter do |e|
        go_sample[e]
      end
    end
  end

  fd(Item).keyboard_request
end

define :sample do |code|
  layout! :yss

  n = notes! code, verse: [font: :courier_prime, size: 14], wh: 1r, 
    suit: Kredki.color([20, 70, 20])
  space! w: 1r, h: :fit, layout: :xec, mi: 10, m: 10 do
    button! "Back", on_click: proc{ window.shift{ list } }
    button! "Run", suit: :orange do
      on_click do
        application.window! do 
          window.wh_drag!
          use! :close_on_esc
          begin
            eval "#{n}" 
          rescue Exception => e
            window.shift do
              fill! :red
              text! "#{e.class}"
            end
          end
        end
      end
    end
  end
end

window.shift{ list }