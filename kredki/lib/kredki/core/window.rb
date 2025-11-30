module Kredki
  class Window
    extend HasFeatures

    def initialize w = 400, h = 400
      @pointer = Pastele.window_new w, h
      ObjectSpace.define_finalizer(self, Window.proc.finalize(@pointer))
    end

    class << self
      attr_accessor :default_action
    end

    self.default_action = Action

    attr_reader :arena

    # Break event loop.
    def terminate! result = nil
      @arena&.terminate! result
    end

    # Maximize window.
    def maximize!
      Pastele.window_maximize @pointer
    end

    # Minimize window.
    def minimize!
      Pastele.window_minimize @pointer
    end

    # Request that a window be raised above other windows and gain the input focus.
    def raise!
      Pastele.window_raise @pointer
    end

    # Request that the size and position of a minimized or maximized window be restored.
    def restore!
      Pastele.window_restore @pointer
    end

    # Set whether the window has an outline.
    def outline! value = true
      return if (c = outline) == (value = block_given? ? yield(c) : value == :not ? !c : value)
      Pastele.window_set_bordered @pointer, value ? 1 : 0
      @outline = value
      true
    end

    # See #outline!.
    def outline= value
      outline! value
    end
    
    # Get whether the window has an outline.
    def outline
      @outline || @outline.nil?
    end

    # See #outline.
    def outline?
      !!outline
    end

    # Set whether fullscreen mode is on.
    def fullscreen! value = true
      return if (c = fullscreen) == (value = block_given? ? yield(c) : value == :not ? !c : value)
      Pastele.window_set_fullscreen @pointer, value ? 1 : 0
      true
    end

    # See #fullscreen!.
    def fullscreen= value
      fullscreen! value
    end
    
    # Get whether fullscreen mode is on.
    def fullscreen
      Pastele.window_get_flags(@pointer) & 0x1000 != 0
    end

    # See #fullscreen.
    def fullscreen?
      !!fullscreen
    end

    # Set whether text input mode is on.
    def text_input! value = true
      return if (c = text_input) == (value = block_given? ? yield(c) : value == :not ? !c : value)
      Pastele.window_set_text_input @pointer, value ? 1 : 0
      true
    end

    # See #text_input!.
    def text_input= value
      text_input! value
    end
    
    # Get whether text input mode is on.
    def text_input
      Pastele.window_get_text_input(@pointer) != 0
    end

    # See #text_input.
    def text_input?
      !!text_input
    end
        
    def opacity! opacity
      set_opacity opacity > 1 ? opacity / 255.0 : opacity
    end

    feature def xy! *xy
      return xy! *Util.cover(yield(self.xy)) if block_given?
      case xy.size
      when 0 then return
      when 1
        x = y = xy[0]
      when 2
        x = xy[0]
        y = xy[1]
      else
        raise_ia xy
      end
      set_position x, y
    end, def xy
      get_position
    end

    flag def resizable! value = true
      return if (c = resizable) == (value = block_given? ? yield(c) : value == :not ? !c : value)
      set_resizable value
      @resizable = value
      true
    end

    feature def wh! *wh
      return wh! *Util.cover(yield(self.wh)) if block_given?
      case wh.size
      when 0 then return
      when 1
        w = h = wh[0]
      when 2
        w = wh[0]
        h = wh[1]
      else
        raise_ia wh
      end
      set_size w, h
    end, def wh
      get_size
    end

    feature def w! w = nil
      return w! yield self.w if block_given?
      set_size w, h
    end, def w
      get_size[0]
    end

    feature def h! h = nil
      return h! yield self.h if block_given?
      set_size w, h
    end, def h
      get_size[1]
    end

    def wh_min! w, h = nil
      Pastele.window_set_minimum_size @pointer, w, h || w
      true
    end

    def wh_min
      point = Pastele::IntPoint.malloc(Fiddle::RUBY_FREE)
      Pastele.window_get_minimum_size @pointer, point
      [point.x, point.y]
    end

    def wh_max! w, h = nil
      Pastele.window_set_maximum_size @pointer, w, h || w
    end

    def wh_max
      point = Pastele::IntPoint.malloc(Fiddle::RUBY_FREE)
      Pastele.window_get_maximum_size @pointer, point
      [point.x, point.y]
    end

    feature def title! title = nil
      return title! yield self.title if block_given?
      return if @title == title
      set_title title.to_s
      @title = title
      true
    end

    flag def top! value = true
      return if (c = top) == (value = block_given? ? yield(c) : value == :not ? !c : value)
      set_top value
      @top = value
      true
    end

    feature def action! action = nil, ...
      action ||= Window.default_action
      if action.is_a? Class
        action = action.new
        set_action action
        action.sketch
      else
        set_action action
      end
      
      action.altered.alter(...)
    end

    def window
      self
    end

    def destroy!
      @arena&.remove_window self
    end

    def_delegators :@arena,
      :window!

    # :section: LEVEL 2

    def self.finalize pointer
      Pastele.window_delete pointer
    end

    attr_writer :arena
    attr :pointer

    def_delegators :action,
      :resolve

    def update_paint paint
      Pastele.window_paint_to_update @pointer, paint.pointer
    end

    def inspect
      "#{self.class}:#{object_id}"
    end

    def set_action action, &block
      action.scene = self
      Pastele.window_set_scene @pointer, action.pointer
      Pastele.window_set_step_handler @pointer, action.step_callback
      update_paint action
      @action = action
    end

    def paint_shown action, direct
      @action == action && !!@arena
    end

    def set_mouse_grab set
      Pastele.window_set_mouse_grab @pointer, set ? 1 : 0
    end

    def get_mouse_grab
      Pastele.window_get_mouse_grab(@pointer) != 0
    end

    def get_capture
      Pastele.window_get_flags(@pointer) & 0x4000 != 0
    end

    def set_opacity opacity
      Pastele.window_set_opacity @pointer, opacity
      true
    end

    def set_position x, y
      Pastele.window_set_position @pointer, x, y
      true
    end

    def get_position
      point = Pastele::IntPoint.malloc(Fiddle::RUBY_FREE)
      Pastele.window_get_position @pointer, point
      [point.x, point.y]
    end

    def set_resizable set
      Pastele.window_set_resizable @pointer, set ? 1 : 0
    end

    def set_size x, y
      Pastele.window_set_size @pointer, x, y
      true
    end

    def get_size
      point = Pastele::IntPoint.malloc(Fiddle::RUBY_FREE)
      Pastele.window_get_size @pointer, point
      [point.x, point.y]
    end

    def set_title title
      Pastele.window_set_title @pointer, title
      true
    end

    def set_top set
      Pastele.window_set_always_on_top @pointer, set ? 1 : 0
    end
  end
end