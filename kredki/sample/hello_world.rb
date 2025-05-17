require 'kredki/ui'

Kredki.run! do |a|
  use! TerminateOnEsc
  window.alter{ resizable!; always_top! }
  color! 10, 30, 10

  layout! :center

  button! m: 5 do
    text << "Hello world!"
    on_click! do
      a.window.terminate!
    end
  end
end