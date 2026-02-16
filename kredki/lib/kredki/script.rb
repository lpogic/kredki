require 'forwardable'
require_relative 'module'

if defined? IRB
  require_relative 'irb'
else
  MainLayer = Kredki.app.open show: false
  module Kredki
    module Extend
      extend Forwardable

      (MainLayer.methods - Object.instance_methods).each do |it|
          def_delegator :MainLayer, it
      end

      def layer! ...
        MainLayer.window.layer!(...)
      end

      def define ...
        def_delegator :MainLayer, Pads.define(...)
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
    title! $0
  end
  MainLayer.carry_focus_on_tab!
end