module Kredki
  module UI
    # Common event resolvers for text navigation.
    module TextNavigation

      def text_navigation text

        on_key_press! :up do |e|
          text.cursor_up e.shift?
          e.resolve
        end

        on_key_press! :down do |e|
          text.cursor_down e.shift?
          e.resolve
        end
    
        on_key_press! :left do |e|
          text.cursor_left e.shift?
          e.resolve
        end
    
        on_key_press! :right do |e|
          text.cursor_right e.shift?
          e.resolve
        end

        on_key_press! :home do |e|
          text.cursor_home e.shift?, e.ctrl?
          e.resolve
        end

        on_key_press! :keypad_seven do |e|
          unless e.num_lock?
            text.cursor_home e.shift?, e.ctrl?
            e.resolve
          end
        end

        on_key_press! :end do |e|
          text.cursor_end e.shift?, e.ctrl?
          e.resolve
        end

        on_key_press! :keypad_one do |e|
          unless e.num_lock?
            text.cursor_end e.shift?, e.ctrl?
            e.resolve
          end
        end

        on_key_press! :a do |e|
          if e.ctrl?
            text.select 0, text.content.length
            e.resolve
          end
        end

        on_key_press! :c do |e|
          if e.ctrl? && text.selection?
            Kredki.clipboard.content = text.selected_content
            e.resolve
          end
        end

        on_mouse_press! :primary do |e|
          if Kredki.keyboard.shift?
            text.drag *text.layer.translate(*e.xy, text)
          else
            if layer.mouse_clicks < 2
              cursor_position = text.cursor_position_for_coordinates *text.layer.translate(*e.xy, text)
              text.set_cursor cursor_position
            end
          end
        end

        on_mouse_move! do |e|
          if e.drag
            text.drag *text.layer.translate(*e.xy, text)
            e.resolve
          end
        end

        on_mouse_free! do |e|
          if e.drag
            text.cursor_position = text.cursor_position_for_coordinates *text.layer.translate(*e.xy, text)
          end
        end

        on_mouse_click! do |e|
          if layer.mouse_clicks == 2 && !Kredki.keyboard.shift?
            sl = text.content.to_s.length
            unless text.cursor_position == sl && text.selection_min == 0 && sl == text.selection_max
              text.select 0, sl
              e.resolve
            end
          end
        end

        on_focus_leave! do |e|
          text.cursor.hide!
          layer&.break_layout
          e.resolve
        end

        on_focus_enter! do |e|
          text.cursor.show!
          e.resolve
        end
      end
    end
  end
end