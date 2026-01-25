require_relative 'kernel-path'

module Kredki

  def self.dir
    File.expand_path "../../..", __FILE__
  end

  module Setup
    class << self
      attr_accessor :sdl
      attr_accessor :thorvg
      attr_accessor :pastele

      attr_accessor :engine
      attr_accessor :config
      attr_accessor :pads_config
      attr_accessor :unit_test_mode
    end
    
  end

  case RUBY_PLATFORM
  when /cygwin|mswin|mingw|bccwin|wince|emx/
    Setup.sdl ||= "#{Kredki.dir}/stuff/dll/SDL3.dll"
    Setup.thorvg ||= "#{Kredki.dir}/stuff/dll/thorvg-1.dll"
    Setup.pastele ||= "#{Kredki.dir}/stuff/dll/pastele.dll"
  when /linux/
    Setup.sdl ||= "#{Kredki.dir}/stuff/so/libSDL3.so"
    Setup.thorvg ||= "#{Kredki.dir}/stuff/so/libthorvg-1.so"
    Setup.pastele ||= "#{Kredki.dir}/stuff/so/libpastele.so"
  end

  Setup.engine = :sw
  Setup.config = "#{Kredki.dir}/lib/kredki/config.rb"
  Setup.pads_config = "#{Kredki.dir}/lib/kredki/pads/config.rb"
end