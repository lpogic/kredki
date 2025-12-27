# Kredki

Kredki is a Ruby gem for creating native graphical applications. Uses ThorVG for drawing and SDL for input processing and windows managing. It includes a small GUI toolkit designed from scratch.

## Installation:

### From RubyGems:

Requirements:
- ruby >= 3.2.2
- gem

Steps:
```SHELL
gem install kredki
```

### From GitHub:

Requirements:
- git
- ruby >= 3.2.2
- gem
- rake

Steps:
```SHELL
git clone https://github.com/lpogic/kredki
cd kredki
rake install 
```

## Usage:

```RUBY
require 'kredki'

button! "Say hello" do
  on_click! do
    puts "Hello world!"
  end
end
```

- Other examples
- Basic concepts
- API documentation

## Development:

### Ruby files only:

Requirements:
- git
- ruby >= 3.2.2
- rake

Steps:
- Clone kredki repository - fork or official (`git clone https://github.com/lpogic/kredki`).
- Navigate to gem root folder (`cd kredki`).
- Run `rake`.
- A window with button should appear. Close the window. In 'sketch/sketch.rb' you can find the code. Feel free to change it and observe changes by running `rake`.
- In kredki directory you can find the gem source code. `rake` command always use this source, even if you have other _kredki_ version installed. Make the changes you need.

### API documentation:

Requirements:
- all for _Ruby files only_
- rdoc

Steps:
- all for _Ruby files only_
- Run `rake rdoc` to update documentation.

### Binaries:

Requirements (_Windows 10_):
- all for _Ruby files only_
- Microsoft Visual Studio with C++ toolchain
- vcpkg (https://learn.microsoft.com/pl-pl/vcpkg/get_started/get-started?pivots=shell-powershell)
- cmake (https://cmake.org/download/)
- meson (https://mesonbuild.com/Getting-meson.html)

Steps:
- all for _Ruby files only_
- Clone repo: `git clone https://github.com/lpogic/thorvg.git -b thorvg-gui`.
- Clone repo: `git clone https://github.com/libsdl-org/SDL.git --depth 1`.
- Run `rake config`.
- Open _rake-config.rb_ and customize paths.
- Run `rake sdl:build`.
- Run `rake thorvg:build`.
- Run `rake build` to build **pastele** and update project binaries.
- Run `rake` to check results.

## Contact

- discord: https://discord.gg/NNrcXKgB