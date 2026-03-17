module Kredki
  # Clipboard interface.
  class Clipboard

    # Set content.
    def set_content content = nil
      return set_content yield self.content if block_given?
      Pastele.clipboard_set_text content.to_s
      true
    end
    
    # See #set_content.
    def content= param
      set_content param
    end
    
    # Get content.
    def content
      ptr = Pastele.clipboard_get_text
      str = ptr.to_s.force_encoding("utf-8")
      ptr.free
      return str
    end

    # Get available mime types in clipboard.
    def mime_types
      mime_types = []
      callback = Fiddle::Closure::BlockCaller.new Fiddle::TYPE_VOID, [Fiddle::TYPE_VOIDP] do |pointer|
        mime_types << pointer.to_s
      end
      Pastele.clipboard_get_mime_types callback
      mime_types
    end
  end
end