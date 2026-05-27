# :crayon::crayon::crayon: Kredki :crayon::crayon::crayon:

Vector graphics & GUI toolkit for [Ruby](https://www.ruby-lang.org/). For creating images, simulations, simple games and applications.

## How it works

The project is based on the [ThorVG](https://www.thorvg.org/) library for rendering and the [SDL](https://www.libsdl.org/) library for connecting with hardware and operating system. Main features:
- created from scratch and deeply integrated with [Ruby](https://www.ruby-lang.org/)
- high level, object oriented API
- configurable and extendible

## Installation

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

## Usage

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
set layout: [:xcc, 10]

label! "Enter name:"
note! size_x: 100, text: "world"
button! "Submit", suit: :orange do
  on_click do
    puts "Hello #{ pane[:note!].text }!"
  end
end
```

Output:

<img src="./.github/enter.png">

In terminal after "Submit" click:

```
Hello world!
```

<hr>

For more check out [kredki/sample](./kredki/sample/).

## Development

`rake` tool is used for development. After cloning _kredki_ repo you can call `rake -T` to display available tasks.

If you develop kredki API only, you can use `rake run` task to test your changes. This command creates sketch/sketch.rb file (if missing) and runs it using draft _kredki_ version.

If you develop _kredki_ dependencies for Windows/Linux, you can make steps below:
1. Run `rake config`, which generates OS dependent configuration template. Then open it, install/clone nessesary utilities and customize paths.
1. `rake sdl:build` to build SDL binary.
1. `rake thorvg:build` to build ThorVG binary.
1. `rake build` to build Pastele binary and update _kredki_ binaries.
1. The last step is usually `rake run` or just `rake` to check if everything is ok.

If you are developing _kredki_ dependencies for a different environment, you can create custom build tasks based on those for Windows or Linux.

## Last updates

- [2026-04-13] The repository is public now.

## Contact

- discord: https://discord.gg/NNrcXKgB
