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

module Kredki
  class Scene
    def_paint :shape!, Shape
    def_paint :rectangle!, Rectangle
    def_paint :ellipse!, Ellipse
    def_paint :picture!, Picture
    def_paint :text!, Text
    def_paint :scene!, Scene
    def_paint :animation!, true do
      new_animation
    end
  end
end

load $kredki_config || 'kredki/config.rb'