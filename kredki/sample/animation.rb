require 'kredki'

# Simple animation sample.

animation! "#{Kredki.dir}/sample/stuff/1643-exploding-star.json", wh: 1r do
  on_mouse_click.animate(self).after{ self.frame! 0 }
end