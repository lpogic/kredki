desc "Generate config template"
task :config do
  generate = true
  if File.exist? "rake-config.rb"
    print "Overwrite 'rake-config.rb'? (y/N): "
    generate = case $stdin.gets.chomp
    when "y", "Y", "YES", "yes"
      true
    end
  end

  if generate
    File.write "rake-config.rb", <<~xx
      # Before building kredki depedencies, install nessesary tools and setup their locations:
      $make =     "cmake" # (https://cmake.org/download/)
      $msbuild =  "C:/Program Files/Microsoft Visual Studio/2022/Community/MSBuild/Current/Bin/MSBuild.exe" # MS Visual Studio build utility
      $vcvars =   "C:/Program Files/Microsoft Visual Studio/2022/Community/VC/Auxiliary/Build/vcvars64.bat"
      $vcpkg =    "C:/Program Files/vcpkg/scripts/buildsystems/vcpkg.cmake" (https://learn.microsoft.com/pl-pl/vcpkg/get_started/get-started?pivots=shell-powershell)
      $sdl =      "C:/Users/user/Projects/SDL" # sdl project root folder (git clone https://github.com/libsdl-org/SDL.git --depth 1)
      $thorvg =   "C:/Users/user/Projects/thorvg" # thorvg project (lpogic fork) root folder (git clone https://github.com/lpogic/thorvg.git -b thorvg-gui)
      $meson =    "meson" # required for building thorvg (https://mesonbuild.com/Getting-meson.html)
    xx
    puts "rake-config.rb created succesfully. Customize it before build kredki depedencies."
  end
end

desc "Build pastele & update project binaries"
task :build => "pastele:build"
task :build => "kredki/stuff/dll"
task :build => "thorvg:import"
task :build => "sdl:import"
task :build => "pastele:import"

directory "kredki/stuff/dll"

namespace :thorvg do
  desc "Build thorvg"
  task :build do
    check_vars :$thorvg, :$vcvars, :$msbuild
    check_vars :$meson, file: false
    chdir $thorvg do
      puts $vcvars
      system $vcvars
      rm_rf "builddir"
      sh "#$meson setup builddir --backend vs " + {
        engines: "['cpu']",
        loaders: "all",
        savers: "all",
        simd: false,
        log: false,
        strip: false,
        threads: false,
        tests: false,
        partial: true
      }.map{|k, v| "-D#{k}=#{v}" }.join(" ")
      sh $msbuild, "#$thorvg/builddir/thorvg.sln", "-m"
    end
  end

  task :import do
    check_vars :$thorvg
    target = "kredki/stuff/dll/thorvg-1.dll"
    source = "#$thorvg/builddir/src/thorvg-1.dll"
    cp source, target
  end
end

namespace :sdl do
  desc "Build sdl"
  task :build do
    check_vars :$sdl, :$vcpkg, :$msbuild
    check_vars :$make, file: false
    chdir $sdl do
      system $vcvars
      rm_rf "builddir"
      mkdir "builddir"
      chdir "builddir"
      sh "#{$make} .. -DCMAKE_TOOLCHAIN_FILE=\"#$vcpkg\""
      sh $msbuild, "#$sdl/builddir/SDL3.sln", "-m", "-p:Configuration=Release"
    end
  end

  task :import do
    check_vars :$sdl
    target = "kredki/stuff/dll/SDL3.dll"
    source = "#$sdl/builddir/Release/SDL3.dll"
    cp source, target
  end
end

namespace :pastele do
  desc "Update pastele sln"
  make = task :make do
    check_vars :$sdl, :$thorvg, :$vcpkg
    check_vars :$make, file: false
    File.write "pastele/CMakeLists.txt", <<~xx
      cmake_minimum_required(VERSION 3.10)

      project(pastele)

      set(HEADERS #{ Dir["*.h", base: "pastele"].join " " })

      set(SOURCES #{ Dir["*.cpp", base: "pastele"].join " " })

      include_directories("#$sdl/include")

      add_library(pastele SHARED ${SOURCES})

      target_sources(pastele PUBLIC ${HEADERS})
      target_include_directories(pastele BEFORE PRIVATE 
        "#$thorvg/inc"
        "#$sdl/include/SDL3"
      )
      target_link_libraries(pastele PRIVATE
        "#$thorvg/builddir/src/thorvg-1.lib"
        "#$sdl/builddir/Release/SDL3.lib"
      )
    xx

    rm_rf "pastele/cmaked"
    mkdir "pastele/cmaked"
    chdir "pastele/cmaked" do
      sh "#{$make} .. -DCMAKE_TOOLCHAIN_FILE=\"#$vcpkg\""
    end
  end

  task :make? do
    if !File.exist?("pastele/cmaked/pastele.sln") || !File.exist?("pastele/CMakeLists.txt")
      make.invoke
    end
  end

  desc "Build pastele"
  task :build => :make?
  task :build => :build!
  task :build => :bind

  task :build! do
    check_vars :$msbuild, :$thorvg, :$sdl
    sln = File.expand_path "pastele/cmaked/pastele.sln"
    system $msbuild, sln, "-m", "-p:Configuration=Release"
  end

  task :bind do
    File.open "kredki/lib/kredki/core/pastele/pastele-extern.rb", "w" do |file|
      file.write <<~xx
      ## File generated from pastele/cabi.h

      module Kredki
        module Pastele
      xx
      File.new("pastele/cabi.h").each_line do |line|
        if lm = /^\s*CABI\s+(.+)\s+(\w+)\((.*)\);/.match(line)
          attributes = lm[3].split(",").map do |attribute|
            attribute_tokens = attribute.split(" ").select{ _1 != "" }
            attribute_type = attribute_tokens[...-1].join " "
            "#{attribute_type} #{attribute_tokens[-1]}"
          end.join ", "
          file.write "    extern '#{lm[1].strip} #{lm[2]}(#{attributes})'\n"
        end
      end
      file.write "  end\nend\n"
    end
  end

  task :import do
    target = "kredki/stuff/dll/pastele.dll"
    source = "pastele/cmaked/Release/pastele.dll"
    cp source, target
  end
end