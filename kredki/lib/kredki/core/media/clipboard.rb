module Kredki
  class Clipboard
    extend HasParams

    param def content! content = nil
      return content! yield self.content if block_given?
      set_text content.to_s
      true
    end, def content
      get_text
    end

    #internal api

    private

    def set_text text
      Abi.clipboard_set_text text
    end

    def get_text
      ptr = Abi.clipboard_get_text
      str = ptr.to_s.force_encoding("utf-8")
      ptr.free
      return str
    end
  end
end