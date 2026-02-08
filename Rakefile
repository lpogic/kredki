require_relative 'rake-config' if File.exist? "rake-config.rb"

task default: :run

desc "[DEFAULT] Run sketch"
task :run => "sketch/sketch.rb"
task :run do
  $LOAD_PATH << File.expand_path(".")
  $LOAD_PATH << File.expand_path("kredki/lib")
  $0 = "sketch/sketch.rb"
  require_relative "sketch/sketch"
end

desc "Run interactive session"
task :irb do
  system "irb -I #{File.expand_path(".")} -I #{File.expand_path("kredki/lib")} -r kredki"
end

directory "sketch"
file "sketch/sketch.rb" => "sketch" do |it|
  cp "kredki/sample/hello_world.rb", it.name
end

task :sample, [:path] do |task, args|
  $LOAD_PATH << File.expand_path(".")
  $LOAD_PATH << File.expand_path("kredki/lib")
  chdir "kredki/sample"
  $0 = args[:path] || "metasample"
  $0 += ".rb" unless $0.end_with? ".rb"
  sample = "kredki/sample/#$0"
  puts "Running: #{sample}"
  require_relative sample
end

require 'rdoc/task'

RDoc::Task.new do |rdoc|
  rdoc.main = "readme.md"
  rdoc.rdoc_files.include("readme.md", "kredki/lib/**/*.rb")
  rdoc.template = "aliki"
end

require "minitest/test_task"

Minitest::TestTask.create(:test) do |t|
  t.libs << "kredki/test"
  t.libs << "kredki/lib"
  t.warning = false
  t.test_globs = ["kredki/test/**/*_test.rb"]
end

def check_vars *vars, file: true
  vars.each do |v|
    value = eval "#{v}"
    raise "\n#{v} is not set. Please complete rake-config.rb and try again.\n\n" if "#{value}".strip.empty?
    raise "\n#{v}(#{value}) not recognized as existing file. Please update rake-config.rb and try again.\n\n" if file && !File.exist?(value)
  end
end

case RUBY_PLATFORM
when /cygwin|mswin|mingw|bccwin|wince|emx/
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
        $make =     "cmake" # (https://cmake.org/download/)
        $msbuild =  "C:/Program Files/Microsoft Visual Studio/2022/Community/MSBuild/Current/Bin/MSBuild.exe" # MS Visual Studio build utility
        $vcvars =   "C:/Program Files/Microsoft Visual Studio/2022/Community/VC/Auxiliary/Build/vcvars64.bat"
        $vcpkg =    "C:/Program Files/vcpkg/scripts/buildsystems/vcpkg.cmake" (https://learn.microsoft.com/pl-pl/vcpkg/get_started/get-started?pivots=shell-powershell)
        $sdl =      "C:/Users/user/Projects/SDL" # sdl project root folder (git clone https://github.com/libsdl-org/SDL.git --depth 1)
        $thorvg =   "C:/Users/user/Projects/thorvg" # thorvg project root folder (git clone https://github.com/lpogic/thorvg.git -b thorvg-gui)
        $meson =    "meson" # required for building thorvg (https://mesonbuild.com/Getting-meson.html)
      xx
      puts "rake-config.rb created succesfully. Customize it then call 'rake build' to update project binaries."
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
          engines: "['sw','gl']",
          loaders: "all",
          savers: "all",
          simd: false,
          log: false,
          strip: false,
          threads: false,
          tests: false,
          partial: false # unstable at the moment
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
when /linux/
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
        $make =     "cmake"        
        $sdl =      "/home/user/SDL" # sdl project root folder
        $thorvg =   "/home/user/thorvg" # thorvg project root folder
        $meson =    "meson" # for thorvg building
        $ninja =    "ninja" # for thorvg building
      xx
      puts "rake-config.rb created succesfully. Edit it and call 'rake build' to update project binaries."
    end
  end

  desc "Build pastele & update project binaries"
  task :build => "pastele:build"
  task :build => "kredki/stuff/so"
  task :build => "thorvg:import"
  task :build => "sdl:import"
  task :build => "pastele:import"
  
  directory "kredki/stuff/so"

  namespace :thorvg do
    desc "Build thorvg"
    task :build do
      check_vars :$thorvg
      check_vars :$meson, file: false
      check_vars :$ninja, file: false
      chdir $thorvg do
        rm_rf "builddir"
        sh "#$meson setup builddir " + {
          engines: "sw",
          loaders: "all",
          savers: "all",
          simd: false,
          log: false,
          strip: false,
          threads: false,
          tests: false,
          partial: false # unstable at the moment
        }.map{|k, v| "-D#{k}=#{v}" }.join(" ")
        sh "#$ninja -C builddir"
      end
    end
  
    task :import do
      check_vars :$thorvg
      target = "kredki/stuff/so/libthorvg-1.so"
      source = "#$thorvg/builddir/src/libthorvg-1.so"
      cp source, target
    end
  end
  
  namespace :sdl do
    desc "Build sdl"
    task :build do
      check_vars :$sdl
      check_vars :$make, file: false
      chdir $sdl do
        rm_rf "builddir"
        mkdir "builddir"
        chdir "builddir" do
          sh "#$make .. -DCMAKE_BUILD_TYPE=Release -DSDL_X11_XTEST=OFF"
          sh "#$make --build . --config Release --parallel"
        end
      end
    end
  
    task :import do
      check_vars :$sdl
      target = "kredki/stuff/so/libSDL3.so"
      source = "#$sdl/builddir/libSDL3.so"
      cp source, target
    end
  end
  
  namespace :pastele do
    desc "Update pastele sln"
    make = task :make do
      check_vars :$sdl, :$thorvg
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
          "#$thorvg/builddir/src/libthorvg-1.so"
          "#$sdl/builddir/libSDL3.so"
        )
      xx
  
      sh "sudo rm -rf #{__dir__}/pastele/cmaked"
      mkdir "pastele/cmaked"
      chdir "pastele/cmaked" do
        sh "#$make .."
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
      check_vars :$thorvg, :$sdl
      check_vars :$make, file: false
      chdir "pastele/cmaked" do
        sh "#$make --build . --config Release --parallel"
      end
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
      target = "kredki/stuff/so/libpastele.so"
      source = "pastele/cmaked/libpastele.so"
      cp source, target
    end
  end
else
  desc "[NOT AVAILABLE] Interactive project configurator"
  task :config do
    raise "Unsupported platform #{RUBY_PLATFORM}!"
  end

  desc "[NOT AVAILABLE] Build pastele & update project binaries"
  task :build do
    raise "Unsupported platform #{RUBY_PLATFORM}!"
  end
end