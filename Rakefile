require_relative 'rake-config' if File.exist? "rake-config.rb"
require 'yard'
require_relative 'yard-extension'

task default: :run

desc "[DEFAULT] Run sketch"
task :run => "sketch/sketch.rb"
task :run do
  $LOAD_PATH << File.expand_path(".")
  $LOAD_PATH << File.expand_path("kredki/lib")
  require_relative "sketch/sketch"
end

desc "Run interactive session"
task :irb do
  system "irb -I #{File.expand_path(".")} -I #{File.expand_path("kredki/lib")} -r kredki"
end

directory "sketch"
file "sketch/sketch.rb" => "sketch" do
  cp "kredki/sample/hello_world.rb", it.name
end

task :sample, [:path] do |task, args|
  if args[:path] == "*"
    chdir "kredki/sample"
    Dir["*.rb"].each do |sample|
      system "rake sample[#{sample}]"
    end
  else
    $LOAD_PATH << File.expand_path(".")
    $LOAD_PATH << File.expand_path("kredki/lib")
    chdir "kredki/sample"
    require_relative "kredki/sample/#{args[:path]}"
  end
end

task :samples do
  Dir["kredki/sample/*.rb"].each do |file|
    puts file
    `rake sample[#{file[14...-3]}]`
  end
end

YARD::Rake::YardocTask.new do |t|
  t.files = ['kredki/lib/**/*.rb', '-', './parameters.md']
  # t.files = ['sketch/sketch.rb']
  t.options = [
    '--tag', 'public', 
    '--hide-tag', 'public', 
    '--query', '@public',
  ]
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
        $msbuild =  "C:/Program Files/Microsoft Visual Studio/2022/Community/MSBuild/Current/Bin/MSBuild.exe"
        $vcvars =   "C:/Program Files/Microsoft Visual Studio/2022/Community/VC/Auxiliary/Build/vcvars64.bat"
        $vcpkg =    "C:/Program Files/vcpkg/scripts/buildsystems/vcpkg.cmake"
        $thorvg =   "C:/Users/user/Projects/thorvg" # thorvg project root folder
        $sdl =      "C:/Users/user/Projects/SDL" # sdl project root folder
        $make =     "cmake"
        $meson =    "meson" # required for building thorvg
      xx
      puts "rake-config.rb created succesfully. Edit it and call 'rake build' to update project binaries."
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
          examples: false,
          engines: "['sw']",
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
      check_vars :$sdl, :$thorvg,  :$vcpkg
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
          "#$thorvg/builddir/src/thorvg.lib"
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
      make.invoke unless File.exist? "pastele/cmaked/pastele.sln"
      
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
      File.open "kredki/lib/kredki/core/abi/tvg.gen.rb", "w" do |file|
        file.write <<~xx
        ## Generated file - manual changes not recommended
  
        module Kredki
          module Abi
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