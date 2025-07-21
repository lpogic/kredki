require_relative '../context_menu/context_menu'
require_relative 'toolbar_layer'
require_relative 'toolbar_primary_layer'
require_relative 'toolbar_option'
require_relative 'toolbar_option_group'

module Kredki
  module UI
    class ToolbarMenu < Pad
      extend HasEventResolvers

      def option!(...)
        @option_group.option!(...)
      end

      event_resolver :on_pick!, Option::PickEvent

      def initialize
        super

        w! 100r
        h! :fit
        xy! 0
        layout! :xwc, space: 4
        color! :gray
      
        @option_group = new ToolbarOptionGroup

        on_pick! do |e|
          keyboard_dispose unless e.target.has_suboption?
        end
      end

    end#ToolbarMenu
  end#UI
end#Kredki