require 'kredki'

# Bounced rotation with loop job.

# button! do |b|
#   alter "Click me!" 
#   b.on_click = job.tap do
#     it.loop do
#       b.rot += it.ms * 0.008
#       it.break if b.rot >= Math::PI
#     end.loop do
#       b.rot -= it.ms * 0.005
#       if b.rot <= 0
#         b.rot = 0
#         it.break
#       end
#     end
#   end
# end


# button! do
#   alter "Click me!" 
#   on_click job: true do
#     it.loop do |j|
#       rot!{ it + j.ms * 0.008 }
#       j.break if rot >= Math::PI
#     end.loop do |j|
#       rot!{ it - j.ms * 0.005 }
#       if rot <= 0
#         rot = 0
#         j.break
#       end
#     end
#   end
# end


button! do |b|
  alter "Click me!" 
  on_click.loop do |j|
    b.rot += j.ms * 0.008
    j.break if rot >= Math::PI
  end.loop do |j|
    b.rot -= j.ms * 0.005
    if rot <= 0
      rot! 0
      j.break
    end
  end
end