class Object
  def raise_ia argument, message = nil
    raise "Invalid argument #{argument.inspect}. #{message}"
  end

  def raise_is state
    raise "Invalid state #{state.inspect}."
  end

  def alter *arg, **narg, &block
    arg.each do |a|
      send :<<, a
    end
    narg.each do |k, v|
      if k =~ /^\w+$/
        send "#{k}=", v
      else
        send k, v
      end
    end
    instance_exec self, &block if block
    self
  end

  def alter_kw skip_unresponding = true, **kw
    kw.each do |keyword, value|
      keyword = "#{keyword}=" if keyword =~ /^\w+$/
      send keyword, value if !skip_unresponding || respond_to?(keyword)
    end
    self
  end

  def send_ahp method, param
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

  def send_branch root, branches
    branches.count{ send_ahp "#{root}_#{_1}!", _2 }.nonzero?
  end
end

class Symbol
  alias_method :old_cmp, :<=>

  def <=> that
    Numeric === that ? 0 : old_cmp(that)
  end
end

class Array
  alias_method :push=, :push
end

module Enumerable
  def each_alter ...
    each{|it| it.alter(...) }
  end

  def each_alter_kw ...
    each{|it| it.alter_kw(...) }
  end
end

class TrueClass
  def not
    false
  end
end

class FalseClass
  def not
    true
  end
end