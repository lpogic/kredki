class Object
  def raise_ia argument
    raise "Invalid argument #{argument.inspect}."
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

  def alter_kwr *arg, **narg, &block
    arg.each do |a|
      send :<<, a
    end
    narg.each do |k, v|
      k = "#{k}=" if k =~ /^\w+$/
      send k, v if respond_to? k
    end
    instance_exec self, &block if block
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