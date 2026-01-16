require 'kredki'

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
    .then do
      # two loops in parallel

      first_loop = it.loop 500 do # in loop with period 500 ms
        fd(TextPad).fill!{ it != :white ? :white : :red }
      end

      it.loop 1000 do # in loop with period 1000 ms
        countdown.call
        it.break if counter < 2 # break the loop
      end.after 1000 do # after 1000 ms
        first_loop.break
        fd(TextPad).alter fill: :yellow, content: "Bye bye"
      end.after 1000 do
        application.exit
      end

    end
  end
end