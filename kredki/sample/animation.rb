require 'kredki'

# A simple animation.

animation! "#{Kredki.dir}/sample/stuff/1643-exploding-star.json", size: 1r do
  job.animate self, true
end