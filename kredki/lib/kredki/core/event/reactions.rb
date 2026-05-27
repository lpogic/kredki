module Kredki
  module Reactions

    def reaction event_class, name
      class_eval <<~xx
        def #{name} ...
          on(#{event_class}, ...)
        end
        
        def #{name}= param
          #{name} do: param
        end
      xx
    end

  end#Reactions
end#Kredki