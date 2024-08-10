require 'optparse'
require 'fileutils'
require_relative '../../lib-update-config'

## copy shared libraries
LIB_MAP.each do |source, target|
  p "#{Dir[source].max} => #{target}"
  FileUtils.cp Dir[source].max, target
end


__END__

## lib-update-config.rb  template

CABI_HEADER = "../pastele/cabi.h"


lib_source = "../pastele/cmaked/Release"
lib_target = "../kredki/ext/dll"
thorvg_project_location = "../thorvg/builddir/src"

LIB_MAP = {
  "#{lib_source}/zlib1.dll" => "#{lib_target}/zlib1.dll",
  "#{lib_source}/libpng16.dll" => "#{lib_target}/libpng16.dll",
  "#{lib_source}/libsharpyuv.dll" => "#{lib_target}/libsharpyuv.dll",
  "#{lib_source}/libwebp.dll" => "#{lib_target}/libwebp.dll",
  "#{lib_source}/SDL2.dll" => "#{lib_target}/SDL2.dll",
  "#{thorvg_project_location}/thorvg-0.dll" => "#{lib_target}/thorvg-0.dll",
  "#{lib_source}/pastele*.dll" => "#{lib_target}/pastele.dll",
}