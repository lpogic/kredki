module Kredki
  # Clipboard interface.
  class Clipboard

    # Set content.
    def content! content = nil
      return content! yield self.content if block_given?
      Pastele.clipboard_set_text content.to_s
      true
    end
    
    # See #content!.
    def content= param
      content! param
    end
    
    # Get content.
    def content
      ptr = Pastele.clipboard_get_text
      str = ptr.to_s.force_encoding("utf-8")
      ptr.free
      return str
    end
  end
end