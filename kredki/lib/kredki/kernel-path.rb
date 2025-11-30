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

  def keyword_safe_alter *arg, **narg, &block
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
end