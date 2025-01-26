require_relative 'layout'

module Kredki
  module UI
    class Aim < Layout
      class << self
        def [](x: :center, y: :center)
          self.new.alter x:, y:;
        end
      end
    end#Aim
  end#UI
end#Kredki