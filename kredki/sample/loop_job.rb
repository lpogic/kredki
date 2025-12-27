require 'kredki'

# Bounced rotation with loop job.

button! do |b|
  text << "Click me!" 
  b.on_click = job.tap do
    it.loop do
      b.rot += it.ms * 0.008
      it.break if b.rot >= Math::PI
    end.loop do
      b.rot -= it.ms * 0.005
      if b.rot <= 0
        b.rot = 0
        it.break
      end
    end
  end
end