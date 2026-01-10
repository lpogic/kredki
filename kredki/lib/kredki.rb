require_relative 'kredki/script'

unless defined? IRB
  at_exit do
    window.show!
    arena.run!
  end
end