require 'kredki'

# Advanced usage of the job API.

button! "Countdown" do
  on_click do |e|
    e.reaction.cancel # cancel reaction at first event

    counter = 5
    countdown = proc do
      set "Exit in #{counter} seconds"
      counter -= 1
    end

    job(&countdown).side do # in another thread
      sleep 1
    end.after do # when last job ends
      countdown.call
    end.after(1000) # wait 1000 ms
    .then do |it|
      # two loops in parallel:

      # first loop
      blink_loop = it.loop 500 do # in loop with period 500 ms
        upper(:text!).alter(:fill){|it| it != :blue ? :blue : :red }
      end

      # second loop
      it.loop 1000 do |it| # in loop with period 1000 ms
        countdown.call
        it.release if counter < 2 # exit the loop
      end.after 1000 do # after 1000 ms
        blink_loop.cancel
        upper(:text!).set "Bye Bye", fill: :white
      end.after 1000 do
        window.close
      end

    end
  end
end