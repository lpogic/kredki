module Kredki
  module Alterable
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
      alter_block_context.instance_exec self, &block if block
      self
    end

    def alter_block_context
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

    def alter_commit
      altered, @altered = @altered, nil
      after_alter altered if altered
      self
    end

    def after_alter altered
      altered.each_key{ send it }
    end

    def altered?
      !!@altered
    end

    def alter_filter sending = nil
      !sending || (@altered[sending] = true) if @altered
    end
  end
end
    