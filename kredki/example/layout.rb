require 'kredki/ui'

Kredki.run! do |a|
  use! TerminateOnEsc
  window.alter{ resizable!; always_top! }
  color! 10, 30, 10

  layouts = Kredki::UI.layouts.keys
  
  pad! color: :rand
  pad! color: :rand
  pad! color: :rand

  layer! do
    layout! :center
    button! m: 5 do
      text << "Click here to change layout"
      on_click! do
        layouts.rotate!
        text << "#{layouts.first || "nil"}"
        a.layout! layouts.first
      end
    end
  end
end