# Kredki

A compact Ruby GUI toolkit.

## Usage:

```RUBY
require 'kredki'

layout! :xcc
mi! 10

note! "world", w: 100
button! "Submit" do
  on_click do
    puts "Hello #{window.fd(:note!).content}!"
    application.exit
  end
end
```

## Installation:

Ruby 3.2.2 or newer is required.

```SHELL
gem install kredki
```

or:

```SHELL
git clone https://github.com/lpogic/kredki
cd kredki
rake install 
```

## Basic usage:

```RUBY
require 'kredki'

button! "Say hello" do
  on_click do
    puts "Hello world!"
  end
end
```

- More examples
- Manual
- API documentation

## Essential rake tasks:
```
rake build          # Build Pastele & update project binaries
rake config         # Generate config template
rake irb            # Run interactive session
rake rdoc           # Build RDoc HTML files
rake run            # [DEFAULT] Run sketch
rake sdl:build      # Build sdl
rake test           # Run the test suite
rake thorvg:build   # Build thorvg
```

## Contact

- discord: https://discord.gg/NNrcXKgB