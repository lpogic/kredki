require 'forwardable'
require_relative 'ui'

if defined? IRB
  require_relative 'irb'
else
  application = Kredki.application!
  W = application.window! show: false
  module Kredki
    module Extend
      extend Forwardable

      (W.methods - Object.instance_methods).each do
          def_delegator :W, it
      end

      def window! ...
        W.application.window!(...)
      end

      def layer! ...
        W.window.layer!(...)
      end

      def define ...
        def_delegator :W, GlobalServices.define(...)
      end

      def plugin! ...
        Kredki.plugin!(...)
      end
    end
  end
  extend Kredki::Extend
  include Kredki
  include Kredki::UI
  extend Forwardable

  use! :exit_on_esc
  use! :carry_focus_on_tab
  window.alter{ wh_drag!; text_input! }
  fill! 110, 301, 101
end