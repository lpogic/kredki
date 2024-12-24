require_relative 'options'

module Kredki
  module UI
    class ToolMenu < Options
      def sketch p0
        super

        direction! :col
      end

      def_pad :option!, Option, fh: 16, h: 20 do
        pad.xy! 3, 2
        submenu_position! :vertical
        submenu_arrow! false
      end
    end#ToolMenu
  end#UI
end#Kredki