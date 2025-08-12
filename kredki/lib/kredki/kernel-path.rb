class Object
  def raise_ia argument
    raise "Invalid argument #{argument.inspect}."
  end

  def raise_is state
    raise "Invalid state #{state.inspect}."
  end
end

class Class
  def enum *symbols, **key_symbols
    @symbols = symbols.each_with_index.to_h + key_symbols
    
    define_method :initialize do |int, symbol|
      @int = int
      @symbol = symbol
    end

    define_singleton_method :[] do |value|
      case value
      when self
        value
      when Integer
        self.new value, @symbols.key(value)
      when Symbol
        self.new @symbols[value], value
      end
    end

    define_method :to_i do
      @int
    end

    define_method :to_sym do
      @symbol
    end
  end

  def struct *fields
    model *fields

    define_singleton_method :[] do |value|
      case value
      when self
        value
      when Array
        self.new *value
      when Hash
        self.new **value
      end
    end

    define_method :to_a do
      model_fields.map{|f| send f.name }
    end
  end
end

class Array
  def polarize other
    both = []
    others = other.reject{|item| both << item if include? item }
    [self - both, both, others]
  end

  def unpack_one
    case size
    when 0 then nil
    when 1 then first
    else self
    end
  end
end