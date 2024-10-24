module Kredki
  module Alterable
    def alter *arg, **narg, &block
      arg.each do |a|
        send :<<, a
      end
      narg.each do |k, v|
        if k.end_with? "!"
          send k, v
        else
          send "#{k}=", v
        end
      end
      instance_exec self, &block if block
      self
    end
  end
end
    