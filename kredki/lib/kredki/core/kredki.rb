module Kredki

  module Util
    class << self

      def eqr a, b
        a == b and (Rational === a) == (Rational === b)
      end

      def polarize left, right
        both = []
        right_only = right.reject{|it| both << it if left.include? it }
        [left - both, both, right_only]
      end

      def uncover array
        case array.size
        when 0 then nil
        when 1 then array.first
        else array
        end
      end

      def cover object
        object.is_a?(Array) ? object : [object]
      end

      def sin01 value
        Math.sin(0.5 * Math::PI * value)
      end
  
      def cos01 value
        Math.cos(0.5 * Math::PI * value)
      end
    end
  end
end

require_relative 'pastele/pastele'

require_relative 'event/event'
require_relative 'event/family/pastele_event'
require_relative 'event/family/focus_enter_event'
require_relative 'event/family/focus_leave_event'
require_relative 'event/family/show_event'
require_relative 'event/family/hide_event'
require_relative 'event/family/drop_event'
require_relative 'event/family/key_event'
require_relative 'event/family/mouse_event'
require_relative 'event/family/tick_event'
require_relative 'event/family/update_complete_event'
require_relative 'event/family/exit_event'
require_relative 'event/family/text_event'
require_relative 'event/family/window_event'
require_relative 'event/family/joystick_event'

require_relative 'paint/paint'
require_relative 'paint/shape'
require_relative 'paint/scene'
require_relative 'paint/area'
require_relative 'paint/shape_area'
require_relative 'paint/block_shape_area'
require_relative 'paint/ellipse'
require_relative 'paint/rectangle'
require_relative 'paint/text'
require_relative 'paint/picture'
require_relative 'paint/animation'
require_relative 'paint/scene_area'

require_relative 'job/job'
require_relative 'job/after_job'
require_relative 'job/loop_job'
require_relative 'job/side_job'
require_relative 'job/play_loop_job'
require_relative 'job/play_job'
require_relative 'job/play_loop_animation_job'
require_relative 'job/play_animation_job'

require_relative 'event/event_manager'
require_relative 'event/keyboard_event_manager'
require_relative 'event/mouse_event_manager'
require_relative 'event/joystick_event_manager'

require_relative 'window/pane'
require_relative 'window/window'
require_relative 'application'

Kredki.application = Kredki::Application

load Kredki.config
