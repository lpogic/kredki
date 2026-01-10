module Kredki
  # Weak container with DSL.
  class The

    # Find object in parent.
    def [](...)
      @parent.[](...)
    end

    # Find in weak map and update object.
    def method_missing name, *a, **na, &b
      if name.end_with? "="
        @map["#{name[...-1]}".to_sym] = a.first
      else
        @map[name]&.alter *a, **na, &b
      end
    end
    
    # :section: LEVEL 2

    def initialize parent
      @parent = parent
      @map = ObjectSpace::WeakMap.new
    end

    def respond_to? name
      true
    end
    
  end#The
end#Kredki