require 'kredki'

# Pad customization overview. Every point gives the same result.

layout! :ybb
mi! 4
params = {wh: 50, corner: 20, fill: :yellow}

# 1. Via named arguments
pad! wh: 50, corner: 20, fill: :yellow

# 2. Via hash argument
pad! params

# 3. Via named arguments (splatted hash)
pad! **params

# 4. Via splatted hash (after creation)
pad = pad!
pad.alter **params

# 5. Via block
pad! do
  wh! 50
  corner! 20
  fill! :yellow
end

# 6. Via definition (procedural)
define :small_pad_proc! do |**na|
  pad! wh: 50, corner: 20, **na
end

small_pad_proc! fill: :yellow

# 7. Via definition (object-oriented)
class SmallPadClass < RectanglePad
  def sketch
    self.fill = :yellow
    corner! 20
  end
end

define :small_pad_class!, SmallPadClass

small_pad_class! wh: 50