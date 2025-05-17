Development:
===

Windows
---

For ruby files:
- Install ruby (version >= 3.4 required)(https://rubyinstaller.org/downloads/)
- Install rake gem (gem install rake)
- Clone kredki (git clone https://github.com/lpogic/kredki.git)
- Go to kredki root folder and run 'rake'.
- Window with Hello world button should appear. 

For binary files:
- Excecute "For ruby files" steps.
- Install Microsoft Visual Studio and install C++ toolchain.
- Install vcpkg (https://learn.microsoft.com/pl-pl/vcpkg/get_started/get-started?pivots=shell-powershell).
- Install cmake (https://cmake.org/download/).
- Install meson (https://mesonbuild.com/Getting-meson.html).
- Clone ThorVG lpogic fork, thorvg-gui branch (git clone https://github.com/lpogic/thorvg.git -b thorvg-gui).
- Clone SDL3 (git clone https://github.com/libsdl-org/SDL.git --depth 1).
- Go to kredki root folder.
- Run 'rake config'
- Open rake-config.rb and customize paths.
- Run 'rake sdl:build' to build SDL project.
- Run 'rake thorvg:build' to build ThorVG project.
- Run 'rake build' to build pastele and update binaries.
- Run 'rake run' to check results.

Tips:
- Run 'rake -T' to display list of available rake commands
- Script executed by 'rake' is sketch/sketch.rb. It is created automaticaly during first run.

Linux
---

In progress