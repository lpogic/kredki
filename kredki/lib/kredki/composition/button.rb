module Kredki
  class Button < Pad

    attr :text

    aliasing def string! str
      @text.string! str
      w! @text.w + 10
      h! @text.font.size + 10
    end, :string=

    def sketch p0
      super

      @text = text! x: 5, y: 5 do
      end
  
      string! "Button"
  
      on_state! do
        body.color = button_top? ? :green : mouse_top? ? :light_gray : :gray
      end
    end
  end
end