module Kredki
  # Event reported by pastele binding.
  class PasteleEvent < Event
    
    # Event timestamp in nanoseconds since SDL binding was initialized.
    def timestamp
      @source.timestamp
    end
    
  end
end