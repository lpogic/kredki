class Object
  def raise_ia argument
    raise "Invalid argument #{argument} of #{argument.class} class."
  end
end

class Module
  def aliasing name, *aliases
    aliases.each{ alias_method it, name }
  end

  def param name, *aliases, get: true
    aliasing name, *aliases.map{ "#{it}!" }
    multi_attr = self.instance_method(name).parameters.then{ it.size > 1 || it.first.first == :rest }
    param_name = name.to_s[...-1]
    if multi_attr
      setter_name = "#{param_name}="
      class_eval <<~XX
        def #{setter_name} param
          Array === param ? (#{name} *param) : (#{name} param)
        end
      XX
      aliasing setter_name, *aliases.map{ "#{it}=" }
    else
      aliasing name, *[param_name, *aliases].map{ "#{it}=" }
    end
    if get
      if get == true
        class_eval <<~XX
          def #{param_name}
            @#{param_name}
          end
        XX
        getter_name = param_name
      else
        getter_name = get
      end
      aliasing getter_name, *aliases
    end
  end

  def param_prefix prefix
    class_eval <<~XX
      def #{prefix}! **param
        param.map{ send "#{prefix}_\#{_1}=", _2 }.reduce(false){ _1 || _2 }
      end
    XX
    class_eval <<~XX
      def #{prefix}= param
        #{prefix}! **param
      end
    XX
  end

  def param_delegate target, *params, get: true
    params.each do |param|
      def_delegators target, "#{param}!".to_sym, "#{param}=".to_sym
      def_delegator target, param if get
    end
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