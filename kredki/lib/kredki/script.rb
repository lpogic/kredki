require 'forwardable'
require_relative 'pads'

if defined? IRB
  require_relative 'irb'
else
  W = Kredki.application!.window! show: false
  module Kredki
    module Extend
      extend Forwardable

      (W.methods - Object.instance_methods).each do |it|
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
  include Kredki::Pads
  extend Forwardable

  use! :exit_on_esc
  use! :carry_focus_on_tab
  window.alter{ wh_drag!; text_input!; fill! 20, 70, 20 }
end