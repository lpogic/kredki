require 'kredki'

# Extended animation sample.

define :anim do |*a, run: nil, name: nil, **na, &b|
  space! wh: 1r do
    area! scene.animation! "stuff/1643-exploding-star.json", run: run
    text! "#{name || run}", fill: :white
  end.alter *a, **na, &b
end

layout! :yss

space! wh: 1r, layout: :xss do
  anim run: :once
  anim run: :back
  anim run: :bounce
end
space! wh: 1r, layout: :xss do
  anim run: :loop
  anim run: :back_loop
  anim run: :bounce_loop
end
space! wh: 1r, layout: :xss do
  anim run: proc{|ms, d| Kredki::Util.sin01 ms, d }, name: "proc sin"
  anim run: proc{|ms, d| Kredki::Util.cos01 ms, d }, name: "proc cos"
  space! wh: 1r
end