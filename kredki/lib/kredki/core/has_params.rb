module Kredki
  module HasParams

    def self.extended mod
      mod.extend Forwardable
    end

    def aliasing name, *aliases
      aliases.each{ alias_method it, name }
    end
  
    def param set, get = true
      if set.end_with?("=")
        param_name = set.to_s[...-1]
      else
        param_name = set.end_with?("!") ? set.to_s[...-1] : set
        if instance_method(set).parameters.then{ it.size > 1 || it.first.first == :rest }
          class_eval <<~xx
            def #{param_name}= param
              Array === param ? (#{set} *param) : (#{set} param)
            end
          xx
        else
          alias_method "#{param_name}=", set
        end
      end
      if get == true
        class_eval <<~xx
          def #{param_name}
            @#{param_name}
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