require 'kredki'

def step1
  button! "Next" do
    on_click do
      window.shift!{ step2 }
    end
  end
end

def step2
  layout! :xcc
  mi! 10
  
  button! "Back" do
    on_click do
      window.shift!{ step1 }
    end
  end

  button! "Good bye!" do
    on_click do
      application.exit
    end
  end
end

window.shift!{ step1 }
