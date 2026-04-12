class Object
  # Raise invalid argument exception.
  def raise_ia argument, message = nil
    raise "Invalid argument #{argument.inspect}. #{message}"
  end

  # Raise invalid state exception.
  def raise_is state
    raise "Invalid state #{state.inspect}."
  end

  # General purpose object altering.
  def set *a, filter_keywords: false, **ka, &block
    a.each{|it| self << it }
    ka.each do |key, arg|
      key = "#{key}=" if key =~ /^\w+$/
      send key, arg if !filter_keywords || self.respond_to?(key)
    end
    instance_exec self, &block if block
    self
  end

  # Parameter DSL helper.
  def send_bundle method, param
    if Array === param
      if Hash === param.last
        *a, h = param
        send method, *a, **h
      else
        send method, *param
      end
    else
      send method, param
    end
  end

  # Another parameter DSL helper.
  def send_branch root, branches, separator = "_"
    branches.count{ send_bundle "#{root}#{separator}#{_1}", _2 }.nonzero?
  end
end

class Symbol
  alias_method :old_cmp, :<=>

  # For DSL purposes ex. size_x_limit: Fit..1r .
  def <=> that
    Numeric === that ? 0 : old_cmp(that)
  end
end

module Enumerable
  # General purpose enumerable objects altering.
  def each_set ...
    each{|it| it.set(...) }
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