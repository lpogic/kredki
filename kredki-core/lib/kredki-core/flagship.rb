module Kredki
  module Flagship

    def def_flag name, nil: false, set: nil, get: nil

      init = binding.local_variable_get :nil
      case get
      when Symbol
        class_eval "def #{name}?; not not #{get}(); end"
        set_common = <<~XX
          cv = (not not #{get}())
          v = value == :~ ? !cv : (not not value)
        XX
      when false
        set_common = <<~XX
          raise ArgumentError.new "Flag can't be negated - no getter available" if value == :~
          cv = nil
          v = (not not value)
        XX
      when true, nil
        class_eval "def #{name}?; @#{name}.nil? ? #{init} : @#{name} ? true : false; end"
        set_common = <<~XX
          cv = @#{name}.nil? ? #{init} : @#{name} ? true : false
          v = value == :~ ? !cv : (not not value)
        XX
      else
        raise ArgumentError.new "#{get.class}"
      end

      case set
      when Symbol
        class_eval <<~XX
          def #{name}=(value)
            #{set_common}
            #{set} v if v != cv
          end
        XX
        class_eval <<~XX
          def #{name}!(value = true)
            #{set_common}
            if v != cv
              #{set} v
              true
            else
              false
            end
          end
        XX
      when false
        false
      when true, nil
        class_eval <<~XX
          def #{name}=(value)
            #{set_common}
            @#{name} = v
          end
        XX
        class_eval <<~XX
          def #{name}!(value = true)
            #{set_common}
            @#{name} = v
            v != cv
          end
        XX
      else 
        raise ArgumentError.new "#{set.class}"
      end
    end
  end
end