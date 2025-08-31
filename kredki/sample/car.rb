require 'kredki'

# Defining custom and complex pads.

define :circle! do
  pad! do
    area! do |w, h|
      m = [w, h].min
      ellipse! m, m
    end
  end
end

define :wheel! do |*a, rim:, tire: :black, **na, &b|
  circle! **na, color: tire do
    circle! wh: 1/2r, color: rim
  end.alter &b
end

define :car_body! do
  pad! do
    area! do |w, h|
      xy! w * 0.0, h * 0.75
      line! w * 0.0, h * 0.45
      line! w * 0.25, h * 0.3
      line! w * 0.4, h * 0.0
      line! w * 0.8, h * 0.0
      line! w * 1.0, h * 0.4
      line! w * 1.0, h * 0.75
    end
  end
end

define :car! do |*a, body: :blue, rim: :gray, tire: :black, **na, &b|
  space! **na do
    car_body! color: body, wh: 1r
    wheel! x: 1/4r, y: End, wh: 1/2r, rim:, tire:;
    wheel! x: 3/4r, y: End, wh: 1/2r, rim:, tire:;
  end.alter &b
end

# We have defined car! pad procedurally. We can use it now as any other pad.

space! wh: 2/3r do
  layout! Y, 60
  car! wh: 1r, rim: :green, body: :orange
  car! wh: 1r, scale: -1, rim: :red, body: :gray
end