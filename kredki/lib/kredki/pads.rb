require_relative 'module'
require_relative 'pads/service/service_inherited'

module Kredki
  module Pads
    extend ServiceInherited

    class << self
      attr_accessor :layout_map

      def layout! id, layout
        @layout_map[id] = layout
      end
  
      def layout param = nil
        case param
        in Layout
          param
        else
          @layout_map[param] or raise "Unknown layout '#{param}'"
        end
      end
    end

    self.layout_map = {}
  end

  require_relative "pads/layout/layout"
  require_relative 'pads/service/event_queue'
  require_relative 'pads/service/service'
  require_relative 'pads/pad/pad'
  require_relative 'pads/pad/sort_pad'
  require_relative 'pads/pad/shape_pad'
  require_relative 'pads/pad/rectangle_pad'
  require_relative 'pads/window_scene'
end

load $kredki_pads_config || "#{__dir__}/pads/config.rb"