module Kredki
  VERSION = "0.1.0"
end

Gem::Specification.new do |s|
  s.name        = "rogal"
  s.version     = Rogal::VERSION
  s.summary     = "Ruby-Oriented Graphic Applications Library"
  s.description = <<~EOT
    The GUI toolkit written in Ruby from skratch. Rendered by ThorVG. Connected with resources via SDL.
  EOT
  s.authors     = ["Łukasz Pomietło"]
  s.email       = "oficjalnyadreslukasza@gmail.com"
  s.files       = [
    *Dir.glob('lib/**/*'),
    *Dir.glob('ext/**/*'),
  ]
  s.homepage    = "https://github.com/lpogic/kredki"
  s.license       = "Zlib"
  s.required_ruby_version     = ">= 3.2.2"
  s.metadata = {
    "documentation_uri" => "https://github.com/lpogic/kredki/blob/main/doc/wiki/README.md",
    "homepage_uri" => "https://github.com/lpogic/kredki"
  }
end