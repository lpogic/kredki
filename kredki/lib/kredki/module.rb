require_relative 'kernel-path'

module Kredki

  def self./ path
    File.expand_path "../../../#{path}", __FILE__
  end

  module Util
    class << self

      def eqr a, b
        a == b and (Rational === a) == (Rational === b)
      end

      def polarize left, right
        both = []
        right_only = right.reject{|it| both << it if left.include? it }
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



if RUBY_PLATFORM =~ /cygwin|mswin|mingw|bccwin|wince|emx/
  $kredki_sdl ||= Kredki / "stuff/dll/SDL3.dll"
  $kredki_thorvg ||= Kredki / "stuff/dll/thorvg-1-1.dll"
  $kredki_pastele ||= Kredki / "stuff/dll/pastele.dll"
elsif !$kredki_sdl || !$kredki_thorvg || !$kredki_pastele
  raise "No default shared libraries for #{RUBY_PLATFORM} found. Provide paths to custom ones in $kredki_sdl, $kredki_thorvg and $kredki_pastele before require 'kredki'"
end

require_relative 'core/kredki'

load $kredki_config || "#{__dir__}/config.rb"