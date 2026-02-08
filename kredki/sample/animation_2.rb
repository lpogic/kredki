require 'kredki'

define :star do |*a, run: nil, name: ""|
  animation! "#{Kredki.dir}/sample/stuff/1643-exploding-star.json", wh: 1r do
    job.animate self, true, &run
    text! name, fill: :white, verse_layout: :ycc
  end
end

layout! :yss

xss! do
  star name: "loop"
  star name: "back\nloop", run: proc{|ms, d| d - ms % d }
  bounce = proc{|ms, d| d2 = d * 2; rem = ms % d2; rem > d ? d2 - rem : rem }
  star name: "bounce\nloop", run: bounce
end
xss! do
  star name: "sin", run: proc{|ms, d| Util.sin01(2.0 * ms / d, 1) * 0.5 * d }
  star name: "cos", run: proc{|ms, d| Util.cos01(2.0 * ms / d, 1) * 0.5 * d }
  space! wh: 1r
end
xss! do
  star name: "fast", run: proc{|ms, d| 2 * ms % d }
  star name: "slow", run: proc{|ms, d| 0.5 * ms % d }
  space! wh: 1r
end