require 'kredki'

# Bounced rotation with loop job.

button! do
  text << "Click me!" 
  s.on_click = job.tap do
    it.loop do
      s.a += it.ms * 0.008
      it.break if s.a >= Math::PI
    end.loop do
      s.a -= it.ms * 0.005
      if s.a <= 0
        s.a = 0
        it.break
      end
    end
  end
end