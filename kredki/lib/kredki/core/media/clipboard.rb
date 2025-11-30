module Kredki
  class Clipboard
    extend HasFeatures

    feature def content! content = nil
      return content! yield self.content if block_given?
      set_text content.to_s
      true
    end, def content
      get_text
    end

    # :section: LEVEL 2

    def set_text text
      Pastele.clipboard_set_text text
    end

    def get_text
      ptr = Pastele.clipboard_get_text
      str = ptr.to_s.force_encoding("utf-8")
      ptr.free
      return str
    end
  end
end