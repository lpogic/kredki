module Kredki
  module HasFeatures

    def self.extended mod
      mod.extend Forwardable
    end
  
    def feature set, get = nil
      raise "Param setter must end with '!'. Given: #{set}" unless set.end_with? "!"
      feature_name = set.to_s[...-1]
      if instance_method(set).parameters.then{ it.size > 1 || it.first.first == :rest }
        class_eval <<~xx
          def #{feature_name}= feature
            Array === feature ? (#{set} *feature) : (#{set} feature)
          end
        xx
      else
        alias_method "#{feature_name}=", set
      end
      if get == nil
        class_eval <<~xx
          def #{feature_name}
            @#{feature_name}
          end
        xx
      elsif get.to_s != feature_name
        raise "Param '#{set} getter shoud be named '#{feature_name}'. Given: #{get}"
      end
    end

    def flag set, get = nil
      feature set, get
      feature_name = set.to_s[...-1]
      if get || get == nil
        class_eval <<~xx
          def #{feature_name}?
            !!#{feature_name}
          end
        xx
      end
    end
    
    def feature_delegate target, *features, get: true
      features.each do |feature|
        def_delegators target, "#{feature}!".to_sym, "#{feature}=".to_sym
        def_delegator target, feature if get
      end
    end
    
  end
end