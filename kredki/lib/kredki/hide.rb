run_at_exit = !defined?(Kredki::Pastele) && !defined?(IRB)

require_relative 'script'

if run_at_exit
  at_exit do
    app.run
  end
end
