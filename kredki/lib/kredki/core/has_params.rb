module Kredki
  module HasParams

    def self.extended mod
      mod.extend Forwardable
    end

    def aliasing name, *aliases
      aliases.each{ alias_method it, name }
    end
  
    def param set, get = nil
      raise "Param setter need to end with '!'. Given: #{set}" unless set.end_with? "!"
      param_name = set.to_s[...-1]
      if instance_method(set).parameters.then{ it.size > 1 || it.first.first == :rest }
        class_eval <<~xx
          def #{param_name}= param
            Array === param ? (#{set} *param) : (#{set} param)
          end
        xx
      else
        alias_method "#{param_name}=", set
      end
      if get == nil
        class_eval <<~xx
          def #{param_name}
            @#{param_name}
          end
        xx
      elsif get.to_s != param_name
        raise "Param '#{set} getter shoud be named '#{param_name}'. Given: #{get}"
      end
    end

    def flag set, get = nil
      param set, get
      param_name = set.to_s[...-1]
      if get || get == nil
        class_eval <<~xx
          def #{param_name}?
            !!#{param_name}
          end
        xx
      end
    end
  
    def param_prefix prefix
      class_eval <<~xx
        def #{prefix}! **param
          param.map{ send "#{prefix}_\#{_1}=", _2 }.reduce(false){ _1 || _2 }
        end
      xx
      class_eval <<~xx
        def #{prefix}= param
          #{prefix}! **param
        end
      xx
    end
  
    def param_delegate target, *params, get: true
      params.each do |param|
        def_delegators target, "#{param}!".to_sym, "#{param}=".to_sym
        def_delegator target, param if get
      end
    end
    
  end
end