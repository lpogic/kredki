require 'kredki'

define :spawn_action do |path, color|
  window.alter :exit_on_esc!
  window.title! path
  window.fill! color

  i = 0
  button! "Spawn #{path}.#{i}" do
    on_click do
      app.open{ spawn_action "#{path}.#{i}", color.tune(0, -10, 10) }
      i += 1
      alter "Spawn #{path}.#{i}"
    end
  end
end

spawn_action "", Kredki.color(window.fill)