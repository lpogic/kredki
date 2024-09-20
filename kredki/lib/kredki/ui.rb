require_relative '../kredki'

module Kredki
  module UI
  end

  require_relative 'ui/pad/pad'
  require_relative 'ui/action'
  require_relative 'ui/input'
  require_relative 'ui/button'
  require_relative 'ui/slide'
  require_relative 'ui/scroll'
  require_relative 'ui/train'
  require_relative 'ui/margin'
  require_relative 'ui/label'
  require_relative 'ui/slice'
  require_relative 'ui/place'
  require_relative 'ui/split'

  module UI
    module PadBase
      def_pad :pad!, Pad
      def_pad :input!, Input
      def_pad :button!, Button
      def_pad :xslide!, XSlide
      def_pad :yslide!, YSlide
      def_pad :scroll!, Scroll
      def_pad :xtrain!, XTrain
      def_pad :ytrain!, YTrain
      def_pad :train!, YTrain
      def_pad :margin!, Margin
      def_pad :label!, Label
      def_pad :slice!, Slice
      def_pad :place!, Place
      def_pad :xsplit!, XSplit
      def_pad :ysplit!, YSplit
      def_pad :split!, YSplit
    end
  end

  Window.default_action = UI::Action
end