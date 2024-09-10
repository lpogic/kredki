module Kredki
  module Alterable
    def alter *arg, **narg, &block
      arg.each do |a|
        send :<<, a
      end
      narg.each do |k, v|
        send "#{k}=", v
      end
      instance_exec self, &block if block
      self
    end
  end
end
    