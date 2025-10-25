require_relative 'kredki/ui'

if defined? IRB
  require_relative 'kredki/irb'
else
  arena = Kredki.arena!
  A = arena.window!
  module Kredki
    module Extend
      extend Forwardable

      (A.methods - Object.instance_methods).each do
          def_delegator :A, it
      end

      def define ...
        def_delegator :A, PadBase.define(...)
      end
    end
  end
  extend Kredki::Extend
  include Kredki
  include Kredki::UI
  extend Forwardable

  use! TerminateOnEsc
  use! CarryFocusOnTab
  window.alter{ resizable!; text_input! }
  color! 110, 301, 101

  if $kredki_run != false
    at_exit do
      arena.run!
    end
  end
end