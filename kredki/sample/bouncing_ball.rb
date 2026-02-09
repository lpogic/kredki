require 'kredki'

ball = ellipse! wh: 100, xy: 100

vy = 0
job.loop do
  ay = it.ms * 0.03
  vy += ay
  ball.y += vy
  bottom = window.h - ball.h
  if ball.y > bottom
    if vy > ay * 1.2
      vy = vy * -0.8
    end
    ball.y = bottom
  end
end