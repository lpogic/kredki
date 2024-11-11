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

    def alter! ...
      altered = alter_begin
      alter(...)
      altered ? alter_commit : self
    end
    
    def alter_begin
      @altered = {} unless @altered
    end

    def alter_commit keep_open = false
      altered, @altered = @altered, nil
      if altered
        after_alter altered
        @altered = {} if keep_open
      end
      self
    end

    def after_alter altered
      altered.each do |k, v|
        send k
      end
    end

    def altered? sending = nil
      !sending || (@altered[sending] = true) if @altered
    end
  end
end
    