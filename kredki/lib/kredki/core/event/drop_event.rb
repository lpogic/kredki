module Kredki
  # Event reported on file drop in window area.
  class FileDropEvent < PasteleEvent
    
    # Get path to dropped file.
    def file
      @file
    end

    # Get main parameter
    def param
      file
    end

    # :section: LEVEL 2

    def initialize abi
      super

      @file = abi.file.to_s.force_encoding("utf-8")
      abi.file.free
    end
  end
  
  # Event reported on drop action begin.
  class DropBeginEvent < Event
  end

  # Event reported on drop action end.
  class DropEndEvent < Event
  end
end