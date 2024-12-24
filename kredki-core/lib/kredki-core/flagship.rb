module Kredki
  module Flagship

    def def_flag name, nil: false, set: nil, get: nil

      init = binding.local_variable_get :nil
      case get
      when Symbol
        class_eval "def #{name}?; not not #{get}(); end"
        set_common = <<~EOT
          cv = (not not #{get}())
          v = value == :~ ? !cv : (not not value)
        EOT
      when false
        set_common = <<~EOT
          raise ArgumentError.new "Flag can't be negated - no getter available" if value == :~
          cv = nil
          v = (not not value)
        EOT
      when true, nil
        class_eval "def #{name}?; @#{name}.nil? ? #{init} : @#{name} ? true : false; end"
        set_common = <<~EOT
          cv = @#{name}.nil? ? #{init} : @#{name} ? true : false
          v = value == :~ ? !cv : (not not value)
        EOT
      else
        raise ArgumentError.new "#{get.class}"
      end

      case set
      when Symbol
        class_eval <<~EOT
          def #{name}=(value)
            #{set_common}
            #{set} v if v != cv
          end
        EOT
        class_eval <<~EOT
          def #{name}!(value = true)
            #{set_common}
            if v != cv
              #{set} v
              true
            else
              false
            end
          end
        EOT
      when false
        false
      when true, nil
        class_eval <<~EOT
          def #{name}=(value)
            #{set_common}
            @#{name} = v
          end
        EOT
        class_eval <<~EOT
          def #{name}!(value = true)
            #{set_common}
            @#{name} = v
            v != cv
          end
        EOT
      else 
        raise ArgumentError.new "#{set.class}"
      end
    end
  end
end