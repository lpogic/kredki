require 'kredki'

# Bounced rotation with loop job.

button! do
  text << "Click me!" 
  s.on_click = job.tap do
    it.loop do
      s.rot += it.ms * 0.008
      it.break if s.rot >= Math::PI
    end.loop do
      s.rot -= it.ms * 0.005
      if s.rot <= 0
        s.rot = 0
        it.break
      end
    end
  end
end