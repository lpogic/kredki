require 'kredki'

# Bounced rotation with loop job.

button! do |b|
  alter "Click me!" 
  on_click.loop do
    b.rot += it.ms * 0.008
    it.break if rot >= Math::PI
  end.loop do
    b.rot -= it.ms * 0.005
    if rot <= 0
      rot! 0
      it.break
    end
  end
end