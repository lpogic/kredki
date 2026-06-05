module Kredki
  module Pads
    class CoupleTrace < Trace
      include Enumerable

      def initialize left, right
        @left = left
        @right = right
      end

      attr :left
      attr :right

      def enlist enum
        @left.enlist enum
        @right.enlist enum
      end

    end
  end#Pads
end#Kredki