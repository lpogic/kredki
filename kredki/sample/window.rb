require 'kredki'

window.title! "Root"
layout! :xcc
mi! 10

button! "Spawn window" do
  on_click do
    application.window! do
      window.title! "Child"

      window.on_window_close do
        p window.title
      end
    end
  end
end

window.on_window_close do
  p window.title
end
