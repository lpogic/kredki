require 'kredki'

# Job api overview

button! do
  text << "Countdown" 
  on_click! do |e|
    e.resolver.detach! # do not resolve more than 1 event

    i = 5
    countdown = proc do
      text << "Exit in #{i} seconds"
      i -= 1
    end

    job(&countdown).tap do
      it.side do # do something in another thread
        sleep 1
      end.after do # then do something immediately
        countdown.call
      end.after(1000).then do # then wait 1000 ms
        it.loop 500 do # then do something in loop with period 500 ms
          text.fill!{ it != :red ? :red : :white }
        end
        it.loop 1000 do # and something in "parallel" loop with period 1000 ms
          countdown.call
          it.break if i < 2 # break the loop conditionally
        end.after 1000 do # then do something after 1000 ms
          text << "Exit in #{i} second"
        end.after 1000 do
          K.terminate!
        end
      end
    end.play
  end
end