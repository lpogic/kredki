require 'kredki'

# A bouncing ball simulation.

ball = ellipse! size: 100, xy: 100

v = 0
job.loop do |it|
  bottom = window.size_y - ball.size_y
  nv = v + it.ms * 0.03
  ball.y += nv ** 2 - v ** 2
  v = nv
  if ball.y > bottom
    v = v > 2.6 ? v * -0.8 : 0
    ball.y = bottom
  end
end