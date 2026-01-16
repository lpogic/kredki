require 'kredki'

# Basic animation sample.

animation! "stuff/1643-exploding-star.json", wh: 1r do
  job.animate self, true
end