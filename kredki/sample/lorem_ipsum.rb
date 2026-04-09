require 'kredki'

window.set_size 550, 300

lorem = <<~XX
  Lorem ipsum dolor sit amet, consectetur adipiscing elit, 
  sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. 
  Ut enim ad minim veniam, quis nostrud exercitation ullamco 
  laboris nisi ut aliquip ex ea commodo consequat. 
  Duis aute irure dolor in reprehenderit in voluptate velit
  esse cillum dolore eu fugiat nulla pariatur.
  Excepteur sint occaecat cupidatat non proident,
  sunt in culpa qui officia deserunt mollit anim id est laborum.
XX

text! "", verse_layout: :ycc

# Run side job (in new thread) which iterates over lorem characters.
job.side do |side_job|
  lorem.each_char do |char|
    # Use Job::report to update GUI state (GUI state should be updated in main thread only).
    side_job.report{ text?.subject += char } 
    sleep rand 0.0..0.1
  end
end