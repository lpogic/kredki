module Kredki
  # Event reported by pastele binding.
  class PasteleEvent < Event
    
    # Event timestamp in nanoseconds since SDL was initialized.
    def timestamp
      @abi.timestamp
    end

    # :section: LEVEL 2

    def initialize abi, target = nil, resolved = false
      super(target, resolved)
      @abi = abi
    end

    def clear
      @abi = nil
    end
  end
end