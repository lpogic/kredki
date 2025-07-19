module Kredki
  class Clipboard

    param def content! content
      set_text content.to_s
    end, get: def content
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