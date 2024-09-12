module Kredki
  class Font
    model :name, :path

    class << self
      attr_accessor :loaded_fonts

      def load path
        name = path_to_name path
        loaded = loaded_fonts[name]
        if loaded
          return loaded if loaded.path == path
          unload name
        end
        Abi.font_load path
        loaded_fonts[name] = Font.new name, path
      end

      def load_from_data name, data, mime_type, copy
        unload name if loaded_fonts[name]
        Abi.font_load_data name, data, data.length, mime_type, copy
        loaded_fonts[name] = Font.new name
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
