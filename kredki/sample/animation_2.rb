require 'kredki'

# An animation running in several play modes.

Pad.star! do |*a, run: nil, name: ""|
  animation! "#{Kredki.dir}/sample/stuff/1643-exploding-star.json", size: 1r do
    job.animate self, true, &run
    text! name, fill: :white, verse_layout: :ycc
  end
end

set_layout :yss

xss! do
  star! name: "loop"
  star! name: "back\nloop", run: proc{|ms, d| d - ms % d }
  bounce = proc do |ms, d| 
    d2 = d * 2
    rem = ms % d2
    rem > d ? d2 - rem : rem
  end
  star! name: "bounce\nloop", run: bounce
end
xss! do
  # Util.sin01 is a helper method which calculates sine function value 
  # of first argument scaled with PI/2 and adds second argument to the result.
  star! name: "sin", run: proc{|ms, d| Util.sin01(2.0 * ms / d, 1) * 0.5 * d }
  # Util.cos01 is like Util.sin01 but with cosine function.
  star! name: "cos", run: proc{|ms, d| Util.cos01(2.0 * ms / d, 1) * 0.5 * d }
  space! size: 1r
end
xss! do
  star! name: "fast", run: proc{|ms, d| 2 * ms % d }
  star! name: "slow", run: proc{|ms, d| 0.5 * ms % d }
  space! size: 1r
end