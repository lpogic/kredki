require 'rogal'

scene do
  animation! "1643-exploding-star.json" do
    ps = 0
    down_before = false
    d = duration
    play! do |ms|
      down = R.mouse.down?
      ps = [ms + ms - ps, ms + d].min if down_before != down
      down_before = down
      [down ? ps - ms : ms - ps, d].min
    end
  end
end