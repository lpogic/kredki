module Kernel
  # Raise invalid argument error.
  def raise_ia argument, message = nil
    raise ArgumentError.new "Invalid argument #{argument.inspect}. #{message}"
  end

  # Raise invalid state error.
  def raise_is state
    raise StandardError.new "Invalid state #{state.inspect}."
  end
end

class Object
  # General purpose object altering.
  def set *a, filter_keywords: false, **ka, &block
    a.each{|it| mixed_set it }
    ka.each do |key, arg|
      key = "#{key}="
      send key, arg if !filter_keywords || respond_to?(key)
    end
    instance_exec self, &block if block
    self
  end

  def mixed_set feature
    case feature
    when Preset
      set *feature.arguments, **feature.keyword_arguments, &feature.block
    when Hash
      set **feature
    when Array
      set *feature
    when Proc
      set &feature
    else
      raise "Unsupported mixed set for (#{feature} : #{feature.class})"
    end
  end

  def nest_set name, ka
    ka.count{|k, v| send "mixed_#{name}_#{k}", v } > 0
  end

  def alter attr
    send "#{attr}=", yield(send attr)
  end
end

class Module
  def feature name
    class_eval <<~xx
      def set_#{name} feature
        return if @#{name} == feature
        @#{name} = feature
        true
      end

      def #{name}
        @#{name}
      end

      def mixed_set_#{name} feature
        case feature
        when Kredki::Preset
          set_#{name} *feature.arguments, **feature.keyword_arguments, &feature.block
        when Array
          if Hash === feature.last
            *a, h = feature
            return set_#{name} *a, **h
          end
          set_#{name} *feature
        when Proc
          set_#{name} &feature
        else
          set_#{name} feature
        end
      end

      alias_method :#{name}=, :mixed_set_#{name}
    xx
  end
end

class Symbol
  alias_method :old_cmp, :<=>

  # For DSL purposes ex. size_x_limit: Fit..1r .
  def <=> that
    Numeric === that ? 0 : old_cmp(that)
  end
end

class TrueClass
  # Negation.
  def not
    false
  end
end

class FalseClass
  # Negation.
  def not
    true
  end
end