module Kredki
  class StepEvent < Event
    model :ms, :<

    def ~()
      ms
    end
  end
end