require_relative 'service/service_inherited'
require_relative "layout/layout"

module Kredki
  module Pads

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

      attr_accessor :config
    end

    self.layout_map = {}
    self.config = "#{Kredki.dir}/stuff/config/pads_config.rb"

    Not = :not
    Auto = :auto
    Fit = :fit
    Ratio = :ratio
    Start = :start
    Center = :center
    End = :end
  end
end