
module Kredki
  module UI
    class List < Pad
      extend Forwardable
      extend HasParams
      extend HasEventResolvers


      def option! *a, **na, &b
        @option_group.option! *a, w: 100r, **na, &b
      end

      #internal api

      def sketch p0
        super

        keyboardy!
        color! :gray
        layout! :y

        @option_group = new OptionGroup
      end

    end
  end
end