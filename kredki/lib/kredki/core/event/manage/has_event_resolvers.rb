module Kredki
  module HasEventResolvers
    def event_resolver name, event_class = nil
      if event_class
        class_eval <<~xx
          def #{name} ...
            on!(#{event_class}, ...)
          end
        xx
      end

      class_eval <<~xx
        def #{name.to_s[...-1]}= resolver
          #{name} do: resolver
        end
      xx
    end
  end
end