require 'kredki'

window.fps_limit = false
ball = ellipse! size: 100, xy: 100

vy = 0
job.loop do
  bottom = window.size_y - ball.size_y
  nvy = vy + it.ms * 0.03
  ball.y += nvy ** 2 - vy ** 2
  vy = nvy
  if ball.y > bottom
    vy = vy > 2.6 ? vy * -0.8 : 0
    ball.y = bottom
  end
end