require 'kredki'

button! do |b|
  set "Click me!" 
  # Run turn job when clicked.
  on_click.loop do |it|
    b.turn += it.ms * 0.002
    it.release if turn >= 0.5
  # Then turn in opposite direction.
  end.loop do |it|
    b.turn -= it.ms * 0.001
    if turn <= 0
      set_turn 0
      it.release
    end
  end
end