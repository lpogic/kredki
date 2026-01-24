require 'kredki'

define :step1 do
  fill! :yellow

  button! "Next" do
    on_click do
      window.shift{ step2 }
    end
  end
end

define :step2 do
  layout! :xcc
  mi! 10
  
  button! "Back" do
    on_click do
      window.shift{ step1 }
    end
  end

  button! "Good bye!" do
    on_click do
      window.close
    end
  end
end

window.shift{ step1 }
