require_relative 'script'

at_exit do
  arena.run!
end