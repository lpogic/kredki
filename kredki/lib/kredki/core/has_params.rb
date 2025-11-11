module Kredki
  module HasParams

    def self.extended mod
      mod.extend Forwardable
    end
  
    def param set, get = nil
      raise "Param setter must end with '!'. Given: #{set}" unless set.end_with? "!"
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
    
    def param_delegate target, *params, get: true
      params.each do |param|
        def_delegators target, "#{param}!".to_sym, "#{param}=".to_sym
        def_delegator target, param if get
      end
    end
    
  end
end