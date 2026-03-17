run_at_exit = !defined?(Kredki::Pastele) && !defined?(IRB)

require_relative 'kredki/script'

if run_at_exit
  at_exit do
    window.set_show
    app.run
  end
end