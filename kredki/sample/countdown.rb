require 'kredki'

# This example shows a slightly more advanced use of the job API.

button! "Countdown" do
  on_click do |e|
    e.reaction.cancel # cancel reaction at first event

    counter = 5
    countdown = proc do
      alter "Exit in #{counter} seconds"
      counter -= 1
    end

    job(&countdown).side do # in another thread
      sleep 1
    end.after do # when last job ends
      countdown.call
    end.after(1000) # wait 1000 ms
    .then do |it|
      # two loops in parallel:

      blink_loop = it.loop 500 do # in loop with period 500 ms
        d?(TextPad).fill!{|it| it != :white ? :white : :red }
      end

      it.loop 1000 do |it| # in loop with period 1000 ms
        countdown.call
        it.release if counter < 2 # mark this iteration as final one
      end.after 1000 do # after 1000 ms
        blink_loop.cancel
        d?(TextPad).alter fill: :yellow, content: "Bye bye"
      end.after 1000 do
        window.close
      end

    end
  end
end