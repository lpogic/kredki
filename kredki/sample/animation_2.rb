require 'kredki'

define :star do |*a, run: nil, name: ""|
  animation! "stuff/1643-exploding-star.json", wh: 1r do
    job.animate self, true, &run
    text! name, fill: :white, verse_layout: :ycc
  end
end

layout! :yss

space! wh: 1r, layout: :xss do
  star name: "loop"
  star name: "back\nloop", run: proc{ _2 - _1 % _2 }
  star name: "bounce\nloop", run: proc{|ms, d| d2 = d * 2; rem = ms % d2; rem > d ? d2 - rem : rem }
end
space! wh: 1r, layout: :xss do
  star name: "sin", run: proc{|ms, d| Kredki::Util.sin01 ms, d }
  star name: "cos", run: proc{|ms, d| Kredki::Util.cos01 ms, d }
  space! wh: 1r
end
space! wh: 1r, layout: :xss do
  star name: "fast", run: proc{|ms, d| ms * 2 % d }
  star name: "slow", run: proc{|ms, d| ms * 0.5 % d }
  space! wh: 1r
end