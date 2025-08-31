require 'kredki'

# Job api overview in single sample

button! do
  text << "Countdown" 
  on_click! do

    i = 10
    job do
      text << "#{i}"
      i -= 1
    end.side do # side job block is running in separate thread - do not modify Kredki state here
      sleep 0.5
    end.after do
      text << "#{i}"
      i -= 1
    end.after 500 do
      text << "#{i}"
      i -= 1
    end.after(500).loop 500 do
      text << "#{i}"
      i -= 1
      it.break if i < 0
    end.after do
      K.terminate!
    end.play

  end
end