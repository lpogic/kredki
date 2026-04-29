module Kredki
  module Pads
    # A service that stores data.
    class DataService < Service

      # Set subject.
      def set_subject subject = @subject
        return send_bundle :set_subject, yield(self.subject) if block_given?
        return if @subject == subject
        @subject = subject
        true
      end

      # See #set_subject.
      def subject= param
        send_bundle :set_subject, param
      end

      # Get subject.
      def subject
        @subject
      end

      # Set a feature recognized by its class.
      def << feature
        feature.is_a?(Symbol) ? super : set_subject(feature)
      end
      
      # Get stored data.
      def get
        @subject
      end
    end
  end
end