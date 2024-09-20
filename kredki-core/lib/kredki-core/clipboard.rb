module Kredki
  class Clipboard

    aliasing def s! string
      set_text string.to_s
    end, :s=, :string!, :string=

    aliasing def s
      get_text
    end, :string

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