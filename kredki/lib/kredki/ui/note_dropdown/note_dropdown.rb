require_relative 'note_dropdown_layer'

module Kredki
  module UI
    class NoteDropdown < Service

      def note! ...
        @note ||= new_service Note
        @note.alter(...)
      end

      attr :note, :picked

      def dropdown! ...
        @dropdown ||= new_service NoteDropdownLayer
        @dropdown.alter(...)
      end

      def option! ...
        dropdown!.option!(...)
      end

      #internal api

      def initialize
        super

        @picked = nil
      end

      def sketch p0
        super

        note!
        dropdown!

        Event.all @note.on_click!, @note.on_key!(:enter) do
          @dropdown.load! @note unless @dropdown.loaded?
        end

        Event.all @note.on_move!, @note.on_resize! do |e|
          @dropdown.load! @note if @dropdown.loaded?
        end
        

        @dropdown.on! Option::PickEvent do |e|
          @dropdown.unload!
          @note.string! ~e, :end
        end

        @dropdown.on_key! :escape do
          @dropdown.unload!
          it.resolve
        end

        @dropdown.on_mouse_button! do
          @dropdown.unload!
        end

        # @note.on_focus_lose! do
        #   @dropdown.unload!
        # end
      end
    end
  end
end