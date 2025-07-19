require_relative 'option'

module Kredki
  module UI
    class YOption < Option
      #internal api

      def sketch p0
        super

        on_key_down! :up do |e|
          parent.update_select_option(:previous)&.roi!
          e.resolve
        end

        on_key_down! :down do |e|
          parent.update_select_option(:next)&.roi!
          e.resolve
        end
      end
    end
  end
end
