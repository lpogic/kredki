require 'kredki'

# Defining custom and complex pads.

define :circle! do
  pad! do
    area! do |sx, sy|
      s = [sx, sy].min
      ellipse! s, s
    end
  end
end

define :wheel! do |*a, rim:, tire: :black, **ka, &b|
  circle! **ka, fill: tire do
    circle! size: 1/2r, fill: rim
  end.alter &b
end

define :car_body! do
  pad! do
    area! do |sx, sy|
      xy! sx * 0.0, sy * 0.75
      line! sx * 0.0, sy * 0.45
      line! sx * 0.25, sy * 0.3
      line! sx * 0.4, sy * 0.0
      line! sx * 0.8, sy * 0.0
      line! sx * 1.0, sy * 0.4
      line! sx * 1.0, sy * 0.75
    end
  end
end

define :car! do |*a, body: :blue, rim: :gray, tire: :black, **ka, &b|
  space! **ka do
    car_body! fill: body, size: 1r
    wheel! x: 1/4r, y: End, size: 1/2r, rim:, tire:;
    wheel! x: 3/4r, y: End, size: 1/2r, rim:, tire:;
  end.alter &b
end



ycc! size: 2/3r do
  spacer! 60
  car! size: 1r, rim: :green, body: :orange
  car! size: 1r, zoom: -1, rim: :red, body: :gray
end