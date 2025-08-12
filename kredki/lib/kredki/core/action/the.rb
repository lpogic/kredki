module Kredki
  class The
    
    def initialize
      @map = ObjectSpace::WeakMap.new
    end

    def respond_to? name
      true
    end

    def method_missing name, *a, **na, &b
      if name.end_with? "="
        @map["#{name[...-1]}".to_sym] = a.first
      else
        @map[name]&.alter *a, **na, &b
      end
    end

  end#The
end#Kredki