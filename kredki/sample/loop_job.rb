require 'kredki'

# Bounced rotation with loop job.

button! do |b|
  alter "Click me!" 
  on_click.loop do |it|
    b.rot += it.ms * 0.008
    it.release if rot >= Math::PI
  end.loop do |it|
    b.rot -= it.ms * 0.005
    if rot <= 0
      rot! 0
      it.release
    end
  end
end