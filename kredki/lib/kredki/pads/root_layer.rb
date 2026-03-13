module Kredki
  module Pads
    # Root window scene layer.
    class RootLayer < Layer

      # Show a window.
      def show!
        window.show!
      end

      # Hide a window.
      def hide!
        window.hide!
      end

      # Maximize a window.
      def maximize!
        window.maximize!
      end

      # Minimize a window.
      def minimize!
        window.minimize!
      end

      # Request that a window be raised above other windows and gain the input focus.
      def focus!
        window.focus!
      end

      # Request that the size and position of a minimized or maximized window be restored.
      def restore!
        window.restore!
      end

      # Hide window and free its memory.
      def close
        window.close
      end

      # Set whether the window has an outline.
      def outline! ...
        window.outline!(...)
      end

      # See #outline!.
      def outline= value
        send_bundle :outline!, value
      end
      
      # Get whether the window has an outline.
      def outline
        window.outline
      end

      # See #outline.
      def outline?
        !!outline
      end

      # Set whether fullscreen mode is on.
      def fullscreen! ...
        window.fullscreen!(...)
      end

      # See #fullscreen!.
      def fullscreen= value
        send_bundle :fullscreen!, value
      end
      
      # Get whether fullscreen mode is on.
      def fullscreen
        window.fullscreen
      end

      # See #fullscreen.
      def fullscreen?
        !!fullscreen
      end

      # Set whether text input mode is on.
      def text_input! ...
        window.text_input!(...)
      end

      # See #text_input!.
      def text_input= value
        send_bundle :text_input!, value
      end
      
      # Get whether text input mode is on.
      def text_input
        window.text_input
      end

      # See #text_input.
      def text_input?
        !!text_input
      end
          
      # Set opacity.
      def opacity! ...
        window.opacity!(...)
      end

      # See #opacity!.
      def opacity= param
        send_bundle :opacity!, param
      end

      # Get opacity.
      def opacity
        window.opacity
      end

      # Set size limit. 
      def size_limit! ...
        window.size_limit!(...)
      end

      # See #size_limit!.
      def size_limit= param
        send_bundle :size_limit!, param
      end

      # Get size limit.
      def size_limit
        window.size_limit
      end

      # Set whether a window width and height can be customized by dragging its border.
      def resizable! ...
        window.resizable!(...)
      end

      # See #resizable!.
      def resizable= param
        send_bundle :resizable!, param
      end

      # Get whether a window width and height can be customized by dragging its border.
      def resizable
        window.resizable
      end

      # See #resizable.
      def resizable?
        !!resizable
      end

      # Set title.
      def title! ...
        window.title!(...)
      end

      # See #title!.
      def title= param
        send_bundle :title!, param
      end

      # Get title.
      def title
        window.title
      end

      # Set whether window is always in the foreground.
      def top! ...
        window.top!(...)
      end

      # See #top!.
      def top= param
        send_bundle :top!, param
      end

      # Get whether window is always in the foreground.
      def top
        window.top
      end

      # See #top.
      def top?
        !!top
      end

      # Get mouse pointer position relative to the window [0, 0].
      def mouse_xy
        x, y = Kredki.mouse.xy
        wx, wy = xy
        [x - wx, y - wy]
      end

      # Set whether mouse pointer is confined to the window.
      def mouse_grab! ...
        window.mouse_grab!(...)
      end

      # See #mouse_grab!.
      def mouse_grab= param
        send_bundle :mouse_grab!, value
      end
      
      # Get whether mouse pointer is confined to the window.
      def mouse_grab
        window.mouse_grab
      end

      # See #mouse_grab.
      def mouse_grab?
        !!mouse_grab
      end

      # Set whether relative mouse mode is on.
      def mouse_relative! ...
        window.mouse_relative!(...)
      end

      # See #mouse_relative!.
      def mouse_relative= param
        send_bundle :mouse_relative!, value
      end
      
      # Get whether relative mouse mode is on.
      def mouse_relative
        window.mouse_relative
      end

      # See #mouse_relative.
      def mouse_relative?
        !!mouse_relative
      end

      # Get whether mouse pointer is in window.
      def mouse_in
        window.mouse_in
      end

      # See #mouse_in.
      def mouse_in?
        !!mouse_in
      end

      # Get whether capture mode is on.
      def mouse_capture
        window.mouse_capture
      end

      # See #capture.
      def mouse_capture?
        !!mouse_capture
      end

      # Set update rate.
      def fps_limit! ...
        window.fps_limit!(...)
      end

      # See #fps_limit!.
      def fps_limit= param
        send_bundle :fps_limit!, param
      end

      # Get update rate.
      def fps_limit
        window.fps_limit
      end
    end
  end
end