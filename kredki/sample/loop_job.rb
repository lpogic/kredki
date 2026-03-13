require 'kredki'

# Bounced rotation with loop job.

button! do |b|
  alter "Click me!" 
  on_click.loop do |it|
    b.turn += it.ms * 0.002
    it.release if turn >= 0.5
  end.loop do |it|
    b.turn -= it.ms * 0.001
    if turn <= 0
      turn! 0
      it.release
    end
  end
end