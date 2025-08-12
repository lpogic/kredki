require_relative 'kredki/ui'

arena = Kredki.arena!
A = arena.window!
module Kredki
  module Extend
    extend Forwardable

    (A.methods - Object.instance_methods).each do
        def_delegator :A, it
    end
  end
end
extend Kredki::Extend
include Kredki
include Kredki::UI

use! TerminateOnEsc
use! CarryFocusOnTab
window.alter{ resizable!; text_input! }
color! 110, 301, 101
layout! :y

at_exit do
  arena.run!
end