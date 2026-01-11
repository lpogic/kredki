module Kredki
  # Common class for event reactions.
  class EventReaction

    # Cancel reaction.
    def cancel
      @manager&.detach self
      @manager = nil
    end

    # Create and attach Kredki::AfterJob to manager.
    def after ...
      @manager&.after(...)
    end

    # Create and attach Kredki::LoopJob to manager.
    def loop ...
      @manager&.loop(...)
    end

    # Create and attach Kredki::SideJob to manager.
    def side ...
      @manager&.side(...)
    end

    # :section: LEVEL 2

    def initialize manager, always
      @manager = manager
      @always = always
    end

    attr_accessor :always

  end
end