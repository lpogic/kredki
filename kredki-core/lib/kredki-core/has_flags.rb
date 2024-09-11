module Kredki
  module HasFlags
    def flags
      @flags ||= {}
    end

    def init_flags instance
      flags.each do |name, value|
        instance.instance_variable_set name, value
      end
    end

    def def_flag name, setter = nil, getter = nil
      init_value = false
      if name.end_with? "!"
        name = name.to_s[...-1]
        init_value = true
      end
      
      if getter.nil? || getter == true || setter.nil? || setter == true
        flags["@#{name}".to_sym] = init_value
      end

      tester = "#{name}?".to_sym

      getter = case getter
      when Proc
        getter
      when Symbol
        flag_symbol_getter getter
      when false
        false
      when true, nil
        flag_var_getter "@#{name}".to_sym
      else
        raise ArgumentError.new "#{getter.class}"
      end

      define_method tester, &getter if getter

      setter = case setter
      when Proc
        setter
      when Symbol
        flag_symbol_setter setter, tester
      when false
        false
      when true
        flag_var_setter "@#{name}".to_sym, tester
      when nil
        flag_var_abi_setter "@#{name}".to_sym, "set_#{name}".to_sym, tester
      else 
        raise ArgumentError.new "#{setter.class}"
      end

      if setter
        define_method "#{name}=", &setter
        define_method "#{name}!", &setter
      end
    end

    private

    def flag_symbol_getter symbol
      proc do
        v = send symbol
        v && v != 0
      end
    end

    def flag_var_getter var
      proc do
        v = instance_variable_get var 
        v && v != 0
      end
    end

    def flag_symbol_setter symbol, tester
      proc do |f = true|
        send symbol, f == :^ ? !send(tester) : !!f
      end
    end

    def flag_var_setter var, tester
      proc do |f = true|
        c = send tester 
        v = f == :^ ? !c : !!f
        instance_variable_set var, v if v != c
      end
    end

    def flag_var_abi_setter var, abi, tester
      proc do |f = true|
        c = send tester
        v = f == :^ ? !c : !!f
        if v != c
          send abi, v ? 1 : 0
          instance_variable_set var, v
        end
      end
    end
  end
end