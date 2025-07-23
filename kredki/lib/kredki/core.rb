require 'procify'
require 'modeling'
require 'koper'
require 'forwardable'
require_relative 'kernel-path'

def ext(path)
  File.expand_path "../../../ext/#{path}", __FILE__
end

if RUBY_PLATFORM =~ /cygwin|mswin|mingw|bccwin|wince|emx/
  $kredki_sdl = ext "dll/SDL3.dll"
  $kredki_thorvg = ext "dll/thorvg-1.dll"
  $kredki_pastele = ext "dll/pastele.dll"
end

require_relative 'core/kredki'
load $kredki_config || 'kredki/config.rb'