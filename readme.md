# :crayon::crayon::crayon: Kredki :crayon::crayon::crayon:

Vector graphics & GUI toolkit for [Ruby](https://www.ruby-lang.org/). For creating images, simulations, simple games and applications.

## How it works:

The project is based on the [ThorVG](https://www.thorvg.org/) library for rendering and the [SDL](https://www.libsdl.org/) library for connecting with hardware and operating system. Main features:
- created from scratch and deeply integrated with [Ruby](https://www.ruby-lang.org/)
- high level, object oriented API
- configurable and extendible

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

Code:

```RUBY
require 'kredki'

window.set_size 400, 200

ellipse! xy: 50, size: 100, fill: :red
rectangle! x: 150, y: 50, size: 100, fill: :green
shape! x: 250, y: 50, size: 100, fill: :blue do |sx, sy|
  jump 0, sy
  line sx / 2, 0
  line sx, sy
end
```

Output:

<img src="./.github/shape.png">

<hr>

Code:

```RUBY
require 'kredki'

window.set_size 400, 150
set layout: :xcc, spacer: 10

label! "Enter name:"
note! size_x: 100, text: "world"
button! "Submit", suit: :orange do
  on_click do
    puts "Hello #{ pane.note?.text }!"
  end
end
```

Output:

<img src="./.github/enter.png">

```SHELL
#> Hello world!
```

<hr>

For more check out [kredki/sample](./kredki/sample/).

## Updates:

- Work in progress

## Contact

- discord: https://discord.gg/NNrcXKgB
- mail: oficjalnyadreslukasza@gmail.com