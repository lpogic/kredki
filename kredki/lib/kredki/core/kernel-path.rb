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

  def nest_set name, ka
    ka.count{|k, v| send "mixed_#{name}_#{k}", v }.zero?.not
  end
end

class Module
  def feature name
    class_eval <<~xx
      def mixed_set_#{name} feature
        if Array === feature
          if Hash === feature.last
            *a, h = feature
            return set_#{name} *a, **h
          end
          return set_#{name} *feature
        end
        set_#{name} feature
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

class NilClass
  # Enables bracket exploration DSL ex. self[:non_existing_pad!][Button][:text] .
  def [](...)
    nil
  end
end