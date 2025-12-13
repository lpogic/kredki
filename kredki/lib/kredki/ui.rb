require_relative 'core'

module Kredki
  module UI
    class << self
      attr_accessor :layout_map

      def layout! id, type, *a
        @layout_map[id] = type.new *a
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
  require_relative 'ui/pad/pad'
  require_relative 'ui/pad/sort_pad'
  require_relative 'ui/pad/rectangle_pad'
  require_relative 'ui/action'

  module UI
    layout! nil, Layout::Align, :c, :c
    [:s, :c, :e].repeated_permutation 2 do
      layout! "a#{it[0]}#{it[1]}".to_sym, Layout::Align, it[0], it[1]
      layout! "x#{it[0]}#{it[1]}".to_sym, Layout::XWay, it[0], it[1]
      layout! "y#{it[0]}#{it[1]}".to_sym, Layout::YWay, it[0], it[1]
    end
  end
end

load $kredki_ui_config || "#{__dir__}/ui/config.rb"