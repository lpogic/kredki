module Kredki
  module UI
    class XOption < Option
      #internal api

      def sketch p0
        super

        on_key_down! :left do |e|
          parent.update_select_option(:previous)&.roi!
          e.resolve
        end

        on_key_down! :right do |e|
          parent.update_select_option(:next)&.roi!
          e.resolve
        end
      end
    end
  end
end
