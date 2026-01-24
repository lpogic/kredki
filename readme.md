# Kredki

Create images, simulations, games and applications. All in Ruby. Have fun!

## Installation:

Ruby 3.3 or newer is required.

```SHELL
gem install kredki
```

or:

```SHELL
git clone https://github.com/lpogic/kredki
cd kredki
rake install 
```

## Usage:

<table><tr><th>
Code
</th><th>
Output
</th></tr><tr><td>

```RUBY
require 'kredki'

window.wh! 400, 200

ellipse! xy: 50, wh: 100, fill: :red
rectangle! x: 150, y: 50, wh: 100, fill: :green
shape! x: 250, y: 50, wh: 100, fill: :blue do |w, h|
  xy! 0, h
  line! w / 2, 0
  line! w, h
end
```

</td><td>
<img src="./.github/shape.png">
</td></tr><tr><td>

```RUBY
require 'kredki'

window.wh! 400, 250
layout! :xcc
mi! 10

label! "Enter name:"
n = note! w: 100, content: "world"
button! "Submit", suit: :orange do
  on_click do
    puts "Hello #{n}!"
  end
end
```

</td><td>
<img src="./.github/hello.png">
</td></tr></table>

## Essential rake tasks:
```
rake build          # Build Pastele & update project binaries
rake config         # Generate config template
rake irb            # Run interactive session
rake rdoc           # Build RDoc HTML files
rake run            # [DEFAULT] Run sketch
rake test           # Run the test suite
```

## Notes


## Contact

- discord: https://discord.gg/NNrcXKgB