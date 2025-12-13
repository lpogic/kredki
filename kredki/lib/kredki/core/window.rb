module Kredki
  class Window

    # Break event loop.
    def terminate! result = nil
      @arena&.terminate! result
    end

    # Maximize a window.
    def maximize!
      Pastele.window_maximize @pointer
    end

    # Minimize a window.
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
      true
    end

    # See #outline!.
    def outline= value
      outline! value
    end
    
    # Get whether the window has an outline.
    def outline
      Pastele.window_get_flags(@pointer) & 0x10 == 0
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
        
    # Set opacity.
    def opacity! opacity = @opacity
      return opacity! yield self.opacity if block_given?
      return if @opacity == opacity
      Pastele.window_set_opacity @pointer, opacity > 1 ? opacity / 255.0 : opacity
      @opacity = opacity
      true
    end

    # See #opacity!.
    def opacity= param
      opacity! param
    end

    # Get opacity.
    def opacity
      @opacity
    end

    # Set position along X and Y axes.
    def xy! x = @x, y = x
      return send_ahp :xy!, yield(self.xy) if block_given?
      Pastele.window_set_position @pointer, x, y
      true
    end

    # See #xy!.
    def xy= param
      send_ahp :wh!, param
    end
    
    # Get position along X and Y axes.
    def xy
      point = Pastele::IntPoint.malloc(Fiddle::RUBY_FREE)
      Pastele.window_get_position @pointer, point
      [point.x, point.y]
    end

    # Set width and height. 
    def wh! w = @w, h = w, **na
      return send_ahp :wh!, yield(self.wh) if block_given?
      if @w != w || @h != h
        Pastele.window_set_size @pointer, w, h
      end | na.count{ send_ahp "wh_#{_1}!", _2 }.nonzero?
    end

    # See #wh!.
    def wh= param
      send_ahp :wh!, param
    end

    # Get width and height.
    def wh
      point = Pastele::IntPoint.malloc(Fiddle::RUBY_FREE)
      Pastele.window_get_size @pointer, point
      [point.x, point.y]
    end

    # Set width and height limit. 
    def wh_limit! w, h = w
      return send_ahp :wh_limit!, yield(self.wh_limit) if block_given?
      w_min, w_max = parse_limit w
      h_min, h_max = parse_limit h
      Pastele.window_set_minimum_size @pointer, w_min, h_min
      Pastele.window_set_maximum_size @pointer, w_max, h_max
      true
    end

    # See #wh_limit!.
    def wh_limit= param
      send_ahp :wh_limit!, param
    end

    # Get width and height limit.
    def wh_limit
      point = Pastele::IntPoint.malloc(Fiddle::RUBY_FREE)
      Pastele.window_get_minimum_size @pointer, point
      w_min, h_min = [point.x, point.y]
      Pastele.window_get_maximum_size @pointer, point
      [w_min..point.x, h_min..point.y]
    end

    # Set whether a window width and height can be customized by dragging its border.
    def wh_drag! value = true
      return if (c = wh_drag) == (value = block_given? ? yield(c) : value == :not ? !c : value)
      Pastele.window_set_resizable @pointer, value ? 1 : 0
      true
    end

    # See #wh_drag!.
    def wh_drag= param
      wh_drag! param
    end

    # Get whether a window width and height can be customized by dragging its border.
    def wh_drag
      Pastele.window_get_flags(@pointer) & 0x20 != 0
    end

    # See #wh_drag.
    def wh_drag?
      !!wh_drag
    end

    # Set title.
    def title! title = nil
      return title! yield self.title if block_given?
      Pastele.window_set_title @pointer, title.to_s
      true
    end

    # See #title!.
    def title= param
      title! param
    end

    # Get title.
    def title
      title = Pastele.window_get_title @pointer
      title.to_s.force_encoding("utf-8");
    end

    # Set whether window is always in the foreground.
    def top! value = true
      return if (c = top) == (value = block_given? ? yield(c) : value == :not ? !c : value)
      Pastele.window_set_always_on_top @pointer, value ? 1 : 0
      true
    end

    # See #top!.
    def top= param
      top! param
    end

    # Get whether window is always in the foreground.
    def top
      Pastele.window_get_flags(@pointer) & 0x10000 != 0
    end

    # See #top.
    def top?
      !!top
    end

    # Set whether the cursor is confined to the window.
    def grab! value = true
      return if (c = grab) == (value = block_given? ? yield(c) : value == :not ? !c : value)
      Pastele.window_set_mouse_grab @pointer, value ? 1 : 0
      true
    end

    # See #grab!.
    def grab= value
      grab! value
    end
    
    # Get whether the cursor is confined to the window.
    def grab
      Pastele.window_get_mouse_grab(@pointer) != 0
    end

    # See #grab.
    def grab?
      !!grab
    end

    # Set whether relative mouse mode is on.
    def mouse_relative! value = true
      return if (c = relative) == (value = block_given? ? yield(c) : value == :not ? !c : value)
      Pastele.window_set_mouse_relative_mode @pointer, value ? 1 : 0
      true
    end

    # See #mouse_relative!.
    def mouse_relative= value
      mouse_relative! value
    end
    
    # Get whether relative mouse mode is on.
    def mouse_relative
      Pastele.window_get_mouse_relative_mode(@pointer) != 0
    end

    # See #mouse_relative.
    def mouse_relative?
      !!mouse_relative
    end

    # Get whether mouse cursor is in window.
    def mouse_in
      @mouse_in.nil? ? Kredki.mouse.get_cursor_position != [0, 0] : @mouse_in
    end

    # See #mouse_in.
    def mouse_in?
      !!mouse_in
    end

    # Set whether capture mode is on.
    def mouse_capture
      Pastele.window_get_flags(@pointer) & 0x4000 != 0
    end

    # See #capture.
    def mouse_capture?
      !!mouse_capture
    end

    # Set and build current action.
    def action! action = Window.default_action, ...
      if action.is_a? Class
        action = action.new
        set_action action
        action.sketch
      else
        set_action action
      end
      action.build_context.alter(...)
    end

    # See #action!.
    def action= param
      send_ahp :action!, param
    end

    # Get current action.
    def action
      @action
    end

    # Get window (self).
    def window
      self
    end

    # Hide window and free its memory.
    def destroy!
      @arena&.remove_window self
    end

    # :section: LEVEL 2

    def initialize w = 400, h = 400
      @pointer = Pastele.window_new w, h
      @arena = nil
      @action = nil
      @mouse_in = nil
      ObjectSpace.define_finalizer(self, Window.proc.finalize(@pointer))
    end

    class << self
      attr_accessor :default_action
    end

    self.default_action = Action

    def self.finalize pointer
      Pastele.window_delete pointer
    end

    attr_accessor :arena
    attr :pointer

    def resolve ...
      @action.resolve(...)
    end

    def update_paint paint
      Pastele.window_paint_to_update @pointer, paint.pointer
    end

    def inspect
      "#{self.class}:#{object_id}"
    end

    def set_action action, &block
      action.scene = self
      Pastele.window_set_scene @pointer, action.pointer
      update_paint action
      @action = action
    end

    def paint_shown action, direct
      @action == action && !!@arena
    end

    def set_mouse_in set
      @mouse_in = set
    end

    def get_capture
      Pastele.window_get_flags(@pointer) & 0x4000 != 0
    end

    def parse_limit limit
      case limit
      when Range
        [limit.begin || 0, limit.end || 0]
      else
        [0, limit || 0]
      end
    end
  end
end