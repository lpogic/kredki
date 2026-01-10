require 'kredki'

window.title! "Root"
layout! :xcc
mi! 10

button! "Spawn window" do
  on_click! do
    arena.window! do
      window.title! "Child"

      window.on_window_close! do
        p window.title
      end

      window.on_quit! do
        p it
        p "XD"
      end
    end
  end
end

window.on_window_close! do
  p window.title
end

window.on_quit! do
 p it
end