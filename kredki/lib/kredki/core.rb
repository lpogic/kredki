require 'procify'
require 'modeling'
require 'koper'
require 'forwardable'
require_relative 'kernel-path'

module Kredki
  module Util
    class << self
      def polarize left, right
        both = []
        right_only = right.reject{ both << it if left.include? it }
        [left - both, both, right_only]
      end

      def uncover array
        case array.size
        when 0 then nil
        when 1 then array.first
        else array
        end
      end

      def cover object
        object.is_a?(Array) ? object : [object]
      end

      def sin01 value, scale = 1
        (Math.sin(Math::PI * value / scale) * 0.5 + 0.5) * scale
      end
  
      def cos01 value, scale = 1
        (Math.cos(Math::PI * value / scale) * 0.5 + 0.5) * scale
      end
    end
  end
end

def stuff(path)
  File.expand_path "../../../stuff/#{path}", __FILE__
end

if RUBY_PLATFORM =~ /cygwin|mswin|mingw|bccwin|wince|emx/
  $kredki_sdl ||= stuff "dll/SDL3.dll"
  $kredki_thorvg ||= stuff "dll/thorvg-1.dll"
  $kredki_pastele ||= stuff "dll/pastele.dll"
end

require_relative 'core/kredki'

load $kredki_config || "#{__dir__}/config.rb"