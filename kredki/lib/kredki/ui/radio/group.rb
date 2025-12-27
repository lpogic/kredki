require_relative 'item'
require_relative 'labeled_item'

module Kredki
  module UI
    module Radio
      # Group of radio items.
      class Group < Service

        # Add new radio item.
        def item! ...
          new(Item, ...)
        end

        # Add new labeled radio item.
        def labeled_item! ...
          p0 = self
          new LabeledItem do
            put! p0.item!
            new Label, "Radio label item"
          end.alter(...)
        end

        # :section: LEVEL 2

        def key event, radio
          case event.key.id
          when :up
            r = previous_radio radio
            r.keyboard_request
            r.roi!
            event.resolve
          when :down
            r = next_radio radio
            r.keyboard_request
            r.roi!
            event.resolve
          end
        end

        def previous_radio radio
          radios = self[Item...].to_a
          radios[radios.index(radio) - 1]
        end

        def next_radio radio
          radios = self[Item...].to_a
          radios[(radios.index(radio) + 1) % radios.size]
        end

        def set_checked radio, checked
          self[Item...].select{ it.checked? }.each{ it.set_checked false } if checked
          radio.set_checked checked
        end
      end#Group
    end#Radio
  end#UI
end#Kredki