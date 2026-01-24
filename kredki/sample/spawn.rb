require 'kredki'

define :spawn do |path, color|
  window.use! :exit_on_esc
  window.title! path
  window.fill! color

  i = 0
  button! "Spawn #{path}.#{i}" do
    on_click do
      application.window!{ spawn "#{path}.#{i}", color.tune(0, -10, 10) }
      i += 1
      alter "Spawn #{path}.#{i}"
    end
  end
end

spawn "", Kredki.color(window.fill)