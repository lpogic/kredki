require_relative 'layout'

module Kredki
  module UI
    class Center < Layout
      class << self
        def [](x = :center, y = :center)
          self.new.alter xy: [x, y]
        end
      end
    end#Center
  end#UI
end#Kredki