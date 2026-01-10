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
  require_relative 'ui/service/service_defines'
  require_relative 'ui/service/pad'
  require_relative 'ui/service/sort_pad'
  require_relative 'ui/service/rectangle_pad'
  require_relative 'ui/window_scene'

  module UI
    layout! nil, Layout::Align.new(:c, :c)
    [:s, :c, :e].repeated_permutation 2 do
      layout! "a#{it[0]}#{it[1]}".to_sym, Layout::Align.new(*it)
      layout! "x#{it[0]}#{it[1]}".to_sym, Layout::XWay.new(*it)
      layout! "y#{it[0]}#{it[1]}".to_sym, Layout::YWay.new(*it)
    end
  end
end

load $kredki_ui_config || "#{__dir__}/ui/config.rb"