module Kredki
  class Font
    model :name, :path

    def initialize path
      @path = path
      @name = Font.load path
    end

    class << self
      attr_accessor :loaded_fonts

      def load path
        name = path_to_name path
        loaded = loaded_fonts[name]
        return name if loaded == path
        unload name if loaded
        Abi.font_load path
        loaded_fonts[name] = path
        name
      end

      def unload font
        name = String === font ? font : font.name
        font = loaded_fonts.delete name
        Abi.font_unload name if font
      end

      def path_to_name path
        path.split("/").last.split(".").first
      end
    end

    self.loaded_fonts = {}
  end
end
