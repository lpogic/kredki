require 'kredki'

# An animation running in several play modes.
# Require: stuff/1643-exploding-star.json

animation_file = "#{Kredki.dir}/sample/stuff/1643-exploding-star.json"

Pad.star! do |*a, run: nil, speed: 1, name: ""|
  animation! animation_file, size: 1r do
    job.play_loop self, speed: speed, &run
    text! name, fill: :white, verse_layout: :ycc
  end
end

set_layout :yss

xss! do
  star! name: "loop"
  star! name: "back\nloop", run: proc{|job| 1 - job.progress(true) }
  star! name: "bounce\nloop", run: proc{|job| 1 - (job.progress(2) - 1).abs }
end
xss! do
  # Util.sin01 is a helper method which calculates sine function value 
  # of first argument scaled with PI/2 and adds second argument to the result.
  star! name: "sin", run: proc{|job| Util.sin01(job.progress) * 0.5 + 0.5 }, speed: 2
  # Util.cos01 is like Util.sin01 but with cosine function.
  star! name: "cos", run: proc{|job| Util.cos01(job.progress) * 0.5 + 0.5 }, speed: 2
  space! size: 1r
end
xss! do
  star! name: "fast", speed: 2
  star! name: "slow", speed: 0.5
  space! size: 1r
end