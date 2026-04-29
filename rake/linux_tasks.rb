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

      $make =     "cmake"        
      $sdl =      "/home/user/SDL" # sdl project root folder (git clone https://github.com/libsdl-org/SDL.git --depth 1)
      $thorvg =   "/home/user/thorvg" # thorvg project (lpogic fork) root folder (git clone https://github.com/lpogic/thorvg.git -b thorvg-gui)
      $meson =    "meson" # required for building thorvg
      $ninja =    "ninja" # required for building thorvg
    xx
    puts "rake-config.rb created succesfully. Customize it before build kredki depedencies."
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
        engines: "cpu",
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