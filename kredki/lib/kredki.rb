require_relative 'kredki/ui'

arena = Kredki.init
A = arena.window!
module Kredki
  extend Forwardable

  (A.methods - Object.instance_methods).each do
      def_delegator :A, it
  end
end
extend Kredki
use! TerminateOnEsc
use! CarryFocusOnTab
window.alter{ resizable!; text_input! }
color! 110, 301, 101

at_exit do
  arena.run!
end