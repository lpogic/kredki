require 'kredki'

# Classic snake game.

GRID = 40

window.set size: [400 / GRID * GRID + 1, 400 / GRID * GRID + 1], resizable: false

service! :snake do
  DIRECTION_MAP = {
    up: [0, -1],
    down: [0, 1],
    left: [-1, 0],
    right: [1, 0],
    w: [0, -1],
    s: [0, 1],
    a: [-1, 0],
    d: [1, 0],
  }

  def sketch
    @body = [
      [11, 10],
      [12, 10],
    ]
    @direction = DIRECTION_MAP[:right]
  end

  def set_direction key_id
    direction = DIRECTION_MAP[key_id]
    if xy_sum(@body[-1], direction) != @body[-2]
      @direction = direction
    end
  end

  def move food_xy
    tail = @body.first
    body = @body[1..]
    head = xy_sum @body.last, @direction
    return :self_collision if body.include? head
    if head == food_xy
      @body = [*@body, head]
      return :food_consumed
    else
      @body = [*body, head]
      return tail
    end
  end

  def head
    @body.last
  end

  def body 
    @body
  end

  def xy_sum a, b
    a.zip(b).map{|it| it.sum % GRID }
  end
end

service! :food do
  def sketch
    @xy = [13, 10]
  end

  def draw prohibited
    @xy = [rand(0...GRID), rand(0...GRID)] while prohibited.include? @xy
    @xy
  end

  def xy
    @xy
  end
end

set layout: [:xss, 1], margin: 1

GRID.times do
  yss! 1 do
    GRID.times do
      pad! size: 400 / GRID - 1, fill: :green
    end
  end
end

job.loop 50 do |job|
  snake = pane[:snake]
  food = pane[:food]
  case move_result = snake.move(food.xy)
  when :self_collision
    snake.body.each do |x, y|
      find(A[:yss!, pad_index: x][:pad!, pad_index: y]).set fill: :gray
    end
    job.cancel
  when :food_consumed
    head = snake.head
    find(A[:yss!, pad_index: head[0]][:pad!, pad_index: head[1]]).set fill: :orange
    food_xy = food.draw snake.body
    find(A[:yss!, pad_index: food_xy[0]][:pad!, pad_index: food_xy[1]]).set fill: :yellow
  else
    head = snake.head
    find(A[:yss!, pad_index: move_result[0]][:pad!, pad_index: move_result[1]]).set fill: :green
    find(A[:yss!, pad_index: head[0]][:pad!, pad_index: head[1]]).set fill: :orange
  end
end

on_key_press :up, :down, :left, :right, :w, :s, :a, :d do |event|
  pane[:snake].set_direction event.key.id
end