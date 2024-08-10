module Kredki
  module HasFlags
    def flag name, setter = nil, getter = nil
      tester = "#{name}?".to_sym

      getter = case getter
      when Proc
        getter
      when Symbol
        g = getter
        proc{ v = send g; !v || v == 0 }
      when false
        false
      else
        var = "@#{name}".to_sym
        proc{ v = instance_variable_get(var); v && v != 0 }
      end

      define_method tester, &getter if getter

      setter = case setter
      when Proc
        setter
      when Symbol
        s = setter
        proc{|f = true| send s, f == :^ ? !send(tester) : !!f }
      when false
        false
      else
        var = "@#{name}".to_sym
        s = "set_#{name}".to_sym
        proc do |f = true|
          current = send tester 
          value = f == :^ ? !current : !!f
          if value != current
            send s, value ? 1 : 0
            instance_variable_set var, value
          end
        end
      end

      if setter
        define_method "#{name}=", &setter
        define_method "#{name}!", &setter
      end
    end

  end
end