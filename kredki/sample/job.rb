require 'kredki'

button! "Countdown" do
  on_click do |e|
    e.reaction.cancel # cancel reaction in first event

    i = 5
    countdown = proc do
      alter "Exit in #{i} seconds"
      i -= 1
    end

    job(&countdown).tap do
      it.side do # do something in another thread
        sleep 1
      end.after do # then do something immediately
        countdown.call
      end.after(1000).then do # then wait 1000 ms
        it.loop 500 do # then do something in loop with period 500 ms
          fd(TextPad).fill!{ it != :white ? :white : :red }
        end
        it.loop 1000 do # and something in "parallel" loop with period 1000 ms
          countdown.call
          it.break if i < 2 # break the loop conditionally
        end.after 1000 do # then do something after 1000 ms
          alter "Exit in #{i} second"
        end.after 1000 do
          application.exit
        end
      end
    end.run window
  end
end