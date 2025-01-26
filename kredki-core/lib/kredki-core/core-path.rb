class Object
  def raise_ia argument
    raise "Invalid argument #{argument} of #{argument.class} class."
  end
end

class Module
  def aliasing name, *a
    a.each{ alias_method _1, name }
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
  def extract
    size > 1 ? self : first
  end

  def polarize other
    both = []
    others = other.reject{|item| both << item if include? item }
    [self - both, both, others]
  end
end

module Enumerable
  def self.zip *enums, &block
    Enumerator.new do |e|
      each = enums.map{ _1.each }
      loop do
        any = false
        values = each.map do |en|
          value = en.next
          any = true
          value
        rescue
          nil
        end
        break unless any
        e << (block ? block.call(*values) : values)
      end
    end
  end
end

class Integer
  def pc
    Rational(self, 100)
  end
end