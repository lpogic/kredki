What's here:

- `kredki/core` - core source code; drawing features, basic event processing, job api
- `kredki/pads` - pads module source code; advanced event processing, gui elements
- `kredki/core.rb` - core only run mode (no gui)
- `kredki/hide.rb` - default run mode but don't display window on start
- `kredki/irb.rb` - interactive session run mode
- `kredki/module.rb` - core + pads run mode without including module at top level
- `kredki/script.rb` - core + pads run mode with including module at top level
- `kredki/setup.rb` - load only bootstrap elements, allows deeper customization like replacing binaries or config files
- `kredki/test.rb` - run mode used in tests
- `kredki.rb` - default run mode, application is started `on_exit`

How to use run selected mode:
```
require 'kredki/module'

Kredki.app do
  text! "Hello"
end
```


How to use setup:
```
require 'kredki/setup'
Kredki.sdl = "./custom_binaries/libSDL3.so"
require 'kredki'

button! "OK"
```