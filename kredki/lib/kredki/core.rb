require 'procify'
require 'modeling'
require 'koper'
require 'forwardable'
require_relative 'kernel-path'

def stuff(path)
  File.expand_path "../../../stuff/#{path}", __FILE__
end

if RUBY_PLATFORM =~ /cygwin|mswin|mingw|bccwin|wince|emx/
  $kredki_sdl ||= stuff "dll/SDL3.dll"
  $kredki_thorvg ||= stuff "dll/thorvg-1.dll"
  $kredki_pastele ||= stuff "dll/pastele.dll"
end

require_relative 'core/kredki'

load $kredki_config || 'kredki/config.rb'