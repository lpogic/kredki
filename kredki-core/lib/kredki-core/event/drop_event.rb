require_relative 'event'

module Kredki
  class FileDropEvent < Event
    
    def initialize ae
      super

      @file = ae.file.to_s.force_encoding("utf-8")
      ae.file.free
    end

    attr :file

    def [](key = :file)
      send key
    end
  end
  
  class DropBeginEvent < Event
  end

  class DropEndEvent < Event
  end
end