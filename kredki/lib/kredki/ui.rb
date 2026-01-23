require_relative 'module'

module Kredki
  module UI
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

  require_relative "ui/layout/layout"
  require_relative 'ui/service/event_queue'
  require_relative 'ui/service/global_services'
  require_relative 'ui/service/service'
  require_relative 'ui/pad/pad'
  require_relative 'ui/pad/sort_pad'
  require_relative 'ui/pad/rectangle_pad'
  require_relative 'ui/window_scene'
end

load $kredki_ui_config || "#{__dir__}/ui/config.rb"