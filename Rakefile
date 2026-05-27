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

namespace :test do
  desc "Commit tests output to expected output"
  task :commit do
    chdir "kredki/test" do
      Dir["*.png", base: "output"].each do |file|
        cp "output/#{file}", file.gsub("__", "/")
      end
    end
  end

  desc "Clean tests output"
  task :clean do
    chdir "kredki/test/output" do
      Dir["*"].each do |file|
        rm_rf file
      end
    end
  end
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
  require_relative 'rake/windows_tasks'
when /linux/
  require_relative 'rake/linux_tasks'
when /darwin/
  require_relative 'rake/macos_tasks'
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
