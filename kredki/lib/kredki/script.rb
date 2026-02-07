require 'forwardable'
require_relative 'module'

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

      def layer! ...
        W.window.layer!(...)
      end

      def define ...
        def_delegator :W, Pads.define(...)
      end
    end
  end
  extend Kredki::Extend
  include Kredki
  include Kredki::Pads
  extend Forwardable

  window.alter do
    wh_drag!
    text_input!
    fill! 20, 70, 20
    exit_on_esc!
  end
  W.carry_focus_on_tab!
end