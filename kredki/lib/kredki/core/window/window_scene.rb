require_relative '../event/event_queue'
require_relative 'the'
require_relative 'window_scene_events'
require_relative 'window_scene_event_manager'

module Kredki
  # Root element of Paint tree.
  class WindowScene < Scene
    include WindowSceneEvents
    
    # Call plugin Proc in WindowScene context.
    def use! id, *a, **na
      plugin = Kredki.plugin id
      raise_ia id unless plugin
      instance_exec *a, **na, &plugin
    end

    # Shift from current scene to another.
    def shift! ...
      @scene.scene!(...)
    end

    # Get Kredki::Window ancestor.
    def window
      self
    end

    # Get Kredki::Application ancestor.
    def application
      @scene&.application
    end

    # Get static object container.
    def the
      @the
    end

    # Set background fill.
    def fill! ...
      @fill.fill!(...)
    end

    # See #fill!.
    def fill= param
      send_ahp :fill!, param
    end

    # Get background fill.
    def fill
      @fill.fill
    end

    def show!
      @scene.show!
    end

    def hide!
      @scene.hide!
    end

    # Maximize a window.
    def maximize!
      @scene.maximize!
    end

    # Minimize a window.
    def minimize!
      @scene.minimize!
    end

    # Request that a window be raised above other windows and gain the input focus.
    def raise!
      @scene.raise!
    end

    # Request that the size and position of a minimized or maximized window be restored.
    def restore!
      @scene.restore!
    end

    # Set whether the window has an outline.
    def outline! ...
      @scene.outline!(...)
    end

    # See #outline!.
    def outline= value
      send_ahp :outline!, value
    end
    
    # Get whether the window has an outline.
    def outline
      @scene.outline
    end

    # See #outline.
    def outline?
      !!outline
    end

    # Set whether fullscreen mode is on.
    def fullscreen! ...
      @scene.fullscreen!(...)
    end

    # See #fullscreen!.
    def fullscreen= value
      send_ahp :fullscreen!, value
    end
    
    # Get whether fullscreen mode is on.
    def fullscreen
      @scene.fullscreen
    end

    # See #fullscreen.
    def fullscreen?
      !!fullscreen
    end

    # Set whether text input mode is on.
    def text_input! ...
      @scene.text_input!(...)
    end

    # See #text_input!.
    def text_input= value
      send_ahp :text_input!, value
    end
    
    # Get whether text input mode is on.
    def text_input
      @scene.text_input
    end

    # See #text_input.
    def text_input?
      !!text_input
    end
        
    # Set opacity.
    def opacity! ...
      @scene.opacity!(...)
    end

    # See #opacity!.
    def opacity= param
      send_ahp :opacity!, param
    end

    # Get opacity.
    def opacity
      @scene.opacity
    end

    # Set position along X and Y axes.
    def xy! ...
      @scene.xy!(...)
    end

    # See #xy!.
    def xy= param
      send_ahp :xy!, param
    end
    
    # Get position along X and Y axes.
    def xy
      @scene.xy
    end

    # Set width and height. 
    def wh! ...
      @scene.wh!(...)
    end

    # See #wh!.
    def wh= param
      send_ahp :wh!, param
    end

    # Get width and height.
    def wh
      @scene.wh
    end

    # Get width.
    def w
      wh[0]
    end

    # Get height.
    def h
      wh[1]
    end

    # Set width and height limit. 
    def wh_limit! ...
      @scene.wh_limit!(...)
    end

    # See #wh_limit!.
    def wh_limit= param
      send_ahp :wh_limit!, param
    end

    # Get width and height limit.
    def wh_limit
      @scene.wh_limit
    end

    # Set whether a window width and height can be customized by dragging its border.
    def wh_drag! ...
      @scene.wh_drag!(...)
    end

    # See #wh_drag!.
    def wh_drag= param
      send_ahp :wh_drag!, param
    end

    # Get whether a window width and height can be customized by dragging its border.
    def wh_drag
      @scene.wh_drag
    end

    # See #wh_drag.
    def wh_drag?
      !!wh_drag
    end

    # Set title.
    def title! ...
      @scene.title!(...)
    end

    # See #title!.
    def title= param
      send_ahp :title!, param
    end

    # Get title.
    def title
      @scene.title
    end

    # Set whether window is always in the foreground.
    def top! ...
      @scene.top!(...)
    end

    # See #top!.
    def top= param
      send_ahp :top!, param
    end

    # Get whether window is always in the foreground.
    def top
      @scene.top
    end

    # See #top.
    def top?
      !!top
    end

    # Get mouse cursor position relative to the window [0, 0].
    def mouse_xy
      x, y = Kredki.mouse.xy
      wx, wy = xy
      [x - wx, y - wy]
    end

    # Set whether mouse cursor is confined to the window.
    def mouse_grab! ...
      @scene.mouse_grab!(...)
    end

    # See #mouse_grab!.
    def mouse_grab= param
      send_ahp :mouse_grab!, value
    end
    
    # Get whether mouse cursor is confined to the window.
    def mouse_grab
      @scene.mouse_grab
    end

    # See #mouse_grab.
    def mouse_grab?
      !!mouse_grab
    end

    # Set whether relative mouse mode is on.
    def mouse_relative! ...
      @scene.mouse_relative!(...)
    end

    # See #mouse_relative!.
    def mouse_relative= param
      send_ahp :mouse_relative!, value
    end
    
    # Get whether relative mouse mode is on.
    def mouse_relative
      @scene.mouse_relative
    end

    # See #mouse_relative.
    def mouse_relative?
      !!mouse_relative
    end

    # Get whether mouse cursor is in window.
    def mouse_in
      @scene.mouse_in
    end

    # See #mouse_in.
    def mouse_in?
      !!mouse_in
    end

    # Get whether capture mode is on.
    def mouse_capture
      @scene.mouse_capture
    end

    # See #capture.
    def mouse_capture?
      !!mouse_capture
    end

    # :section: LEVEL 2

    def initialize
      super

      @jobs = []
      @event_manager = WindowSceneEventManager.new
      @event_queue = EventQueue.new
      @fill = rectangle! xy: 0
      @the = The.new self

      on_clock_tick do: method(:tick)
    end

    attr :event_queue

    def update_paint paint
      @scene&.update_paint paint
    end

    def sketch
      on_window_resize{ @fill.wh = it.wh }
      @fill.wh = *wh
      fill! 20, 70, 20
    end

    def translate x, y, target = nil
      if target
        xy = target.translate -x, -y
        [-xy[0], -xy[1]]
      else
        [x, y]
      end
    end

    def screen_translate x, y, target = nil
      wx, wy = xy
      translate x - wx, y - wy, target
    end

    def put_job job
      @jobs << job unless @jobs.include? job
    end

    def remove_job job
      @jobs.delete job
    end

    def report event
      @event_queue.push event, self
    end

    def report event, early = false
      @event_manager.report event
    end

    def tick event
      ms = event.timestamp / 1_000_000 - application.run_ms
      @jobs.filter!{ it.tick ms }
    end

    def build_context
      self
    end
  end
end
