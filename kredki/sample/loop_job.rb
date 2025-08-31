require 'kredki'

# Bounced rotation with loop job.

button! do
  text << "Click me!" 
  s.on_click = job.loop do
    s.spin += it.ms * 0.008
    it.break if s.spin >= Math::PI
  end.loop do
    s.spin -= it.ms * 0.005
    if s.spin <= 0
      s.spin = 0
      it.break
    end
  end
end