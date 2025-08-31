require 'kredki'

# Sample shows different ways of parametrization. Every case gives same result.

layout! Y, 4

# 1. Via named arguments
pad! wh: 50, rbb: 20, ree: 20, color: :yellow

# 2. Via hash argument
params = {wh: 50, rbb: 20, ree: 20, color: :yellow}
pad! params

# 3. Via named arguments (splatted hash)
pad! color: :green, **params

# 4. Via block
pad! do
  wh! 50
  rbb! 20
  ree! 20
  color! :yellow
end

# 5. Via procedural definition
define :small_pad! do |**na|
  pad! wh: 50, rbb: 20, ree: 20, **na
end

small_pad! color: :yellow

# 6. Via splatted hash (after creation)
pad = pad!
pad.alter **params