module Kredki
  class Button < Pad

    attr :text

    aliasing def string! str
      @text.string! str
      w! @text.w + 10
      h! @text.h + 10
    end, :string=

    def sketch p0
      super

      @text = text! x: 5, y: 5 do
      end
  
      string! "Button"
  
      on_state! do
        color = Kredki.color :gray
        body.color = button_top? ? :green : mouse_top? ? color.light : color
      end
    end
  end
end