module Kredki
  class Font
    model :name, :size, :style do
    end

    def to_array
      [@name, @size, @style]
    end

    def ==(other)
      Font === other &&
      name == other.name && 
      size == other.size && 
      style == other.style
    end

    class << self
      attr_accessor :loaded_fonts

      def [](param)
        case param
        when Font
          param
        when String
          Font.new param, 20
        when Array
          param[0] = loaded_fonts[param[0]] if !(String === param[0])
          Font.new *param
        else
          Font.new loaded_fonts[param], 20
        end
      end

      def load id, path
        name = path_to_name path
        if !loaded_fonts[id] && !loaded_fonts.key(name)
          Abi.font_load path
          loaded_fonts[id] = name
        end
      end

      def load_from_data id, data, mime_type, copy
        name = id.to_s
        if !loaded_fonts[id] && !loaded_fonts.key(name)
          Abi.font_load_data name, data, data.length, mime_type, copy
          loaded_fonts[id] = name
        end
      end

      def unload id
        name = loaded_fonts.delete id
        Abi.font_unload name if name
      end

      def path_to_name path
        path.split("/").last.split(".").first
      end
    end

    self.loaded_fonts = {}
  end
end
