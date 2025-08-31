require 'kredki'

# Extended animation sample.

define :anim do |*a, play: nil, name: nil, **na, &b|
  space! wh: 1r do
    area! scene.animation! "1643-exploding-star.json", play: play
    text! "#{name || play}", color: :black
  end.alter *a, **na, &b
end

layout! Y

space! wh: 1r, layout: X do
  anim play: :once
  anim play: :back
  anim play: :bounce
end
space! wh: 1r, layout: X do
  anim play: :loop
  anim play: :back_loop
  anim play: :bounce_loop
end
space! wh: 1r, layout: X do
  anim play: proc{|ms, d| K.sin01 ms, d }, name: "proc sin"
  anim play: proc{|ms, d| K.cos01 ms, d }, name: "proc cos"
  space! wh: 1r
end