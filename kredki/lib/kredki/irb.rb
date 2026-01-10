require 'irb'

class KredkiWorkSpace < IRB::WorkSpace
  def initialize ...
    super
    @mutex = Thread::Mutex.new
    @convar = Thread::ConditionVariable.new
    @cmd = nil
  end

  alias_method :oeval, :evaluate

  def evaluate *a
    @mutex.synchronize do
      @cmd = a
      @convar.wait @mutex
      result = @cmd
      @cmd = nil
      result
    end
  end

  def release
    @mutex.synchronize do
      if @cmd
        if @cmd == [:exit]
          Kredki.exit!
        else
          @cmd = oeval *@cmd
        end
        @convar.signal
      end
    end
  end
end

KredkiProc = proc do
  mutex = Thread::Mutex.new
  convar = Thread::ConditionVariable.new
  Thread.new do
    arena = Kredki.arena!
    W = arena.window! show: false
    module Kredki
      module Extend
        extend Forwardable

        (W.methods - Object.instance_methods).each do
            def_delegator :W, it
        end

        def window! ...
          W.arena.window!(...)
        end
  
        def layer! ...
          W.window.layer!(...)
        end
  
        def define ...
          def_delegator :W, ServiceDefines.define(...)
        end
  
        def plugin! ...
          Kredki.plugin!(...)
        end
      end
    end
    extend Kredki::Extend
    include Kredki
    include Kredki::UI
    extend Forwardable

    use! :exit_on_esc
    use! :carry_focus_on_tab
    window.alter{ wh_drag!; text_input!; top! }
    fill! 110, 301, 101

    kredki_workspace = KredkiWorkSpace.new binding
    IRB.CurrentContext.replace_workspace kredki_workspace
    IRB.conf[:AT_EXIT] << proc{ kredki_workspace.evaluate :exit }
    loop!{ kredki_workspace.release }
    mutex.synchronize{ convar.signal }
    window.show!
    arena.run!
  end

  mutex.synchronize{ convar.wait mutex }
end

if IRB.CurrentContext
  KredkiProc.call
else
  module IRB
    class Irb
      alias_method :o_configure_io, :configure_io
      def configure_io
        KredkiProc.call
        o_configure_io
      end
    end
  end
end