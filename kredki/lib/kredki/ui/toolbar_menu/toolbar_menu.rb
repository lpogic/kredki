require_relative '../context_menu/context_menu'
require_relative 'toolbar_layer'
require_relative 'toolbar_primary_layer'
require_relative 'toolbar_item'
require_relative 'toolbar_item_group'

module Kredki
  module UI
    class ToolbarMenu < ShapePad
      extend HasEventResolvers

      def item!(...)
        @item_group.item!(...)
      end

      event_resolver :on_pick!, Item::PickEvent

      def initialize
        super

        w! 1r
        h! :fit
        xy! 0
        layout! :xbc, 4
        color! :gray
      
        @item_group = new ToolbarItemGroup

        on_pick! do |e|
          keyboard_dispose unless e.target.has_subitem?
        end
      end

    end#ToolbarMenu
  end#UI
end#Kredki