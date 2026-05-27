require 'forwardable'
require_relative 'module'

if defined? IRB
  require_relative 'irb'
else
  MainLayer = Kredki.application.open hidden: true
  module Kredki
    module Extend
      extend Forwardable

      (MainLayer.methods - Object.instance_methods).each do |it|
          def_delegator :MainLayer, it
      end
    end
  end
  extend Kredki::Extend
  include Kredki
  include Kredki::Pads

  window.set do
    set_resizable true
    set_text_input true
    pane.set_fill 20, 70, 20
    pane.close_on_esc
    set_title $0
  end
  MainLayer.carry_focus_on_tab
end