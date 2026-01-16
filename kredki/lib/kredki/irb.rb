require 'irb'

class KredkiWorkSpace < IRB::WorkSpace
  def initialize application, ...
    super(...)
    @application = application
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
          @application.exit
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
    application = Kredki.application!
    W = application.window! show: false
    module Kredki
      module Extend
        extend Forwardable

        (W.methods - Object.instance_methods).each do
            def_delegator :W, it
        end

        def window! ...
          W.application.window!(...)
        end
  
        def layer! ...
          W.window.layer!(...)
        end
  
        def define ...
          def_delegator :W, GlobalServices.define(...)
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
    window.alter{ wh_drag!; text_input!; fill! 20, 70, 20; top! }

    kredki_workspace = KredkiWorkSpace.new application, binding
    IRB.CurrentContext.replace_workspace kredki_workspace
    IRB.conf[:AT_EXIT] << proc{ kredki_workspace.evaluate :exit }
    job.loop{ kredki_workspace.release }
    mutex.synchronize{ convar.signal }
    window.show!
    application.run
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