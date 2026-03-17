require 'irb'

class KredkiWorkSpace < IRB::WorkSpace
  def initialize app, ...
    super(...)
    @app = app
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
          @app.return
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
    app = Kredki.app
    MainLayer = app.open show: false
    module Kredki
      module Extend
        extend Forwardable

        (MainLayer.methods - Object.instance_methods).each do |it|
            def_delegator :MainLayer, it
        end
      end
    end
    extend Kredki::Extend
    include Kredki
    include Kredki::Pads
    
    window.set do
      set_resizable
      set_text_input
      set_fill 20, 70, 20
      set_top
      exit_on_esc
    end
    MainLayer.carry_focus_on_tab

    kredki_workspace = KredkiWorkSpace.new app, binding
    IRB.CurrentContext.replace_workspace kredki_workspace
    IRB.conf[:AT_EXIT] << proc{ kredki_workspace.evaluate :exit }
    job.loop{ kredki_workspace.release }
    mutex.synchronize{ convar.signal }
    window.show
    app.run
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