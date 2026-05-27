require 'kredki'

class SpawnPane < Pane
  layer! do |path, color|
    window.set title: path
    pane.set fill: color
    pane.close_on_esc

    i = 0
    button! "Spawn #{path}.#{i}" do
      on_click do
        application.open SpawnPane.new("#{path}.#{i}", color.tune(0, -10, 10))
        i += 1
        set "Spawn #{path}.#{i}"
      end
    end
  end
end

window.set SpawnPane.new("", Kredki.color(pane.fill))