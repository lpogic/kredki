require 'kredki'

# Simple animation sample.

animation! "#{Kredki.dir}/sample/stuff/1643-exploding-star.json", wh: 1r do
  job.animate self, true
end