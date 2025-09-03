module Kredki
  VERSION = "0.1.0"
end

Gem::Specification.new do |s|
  s.name        = "kredki"
  s.version     = Kredki::VERSION
  s.summary     = "Ruby-Oriented graphical application toolkit"
  s.description = <<~EOT
    A library for playing with vector graphics in Ruby. It allows you to create simple simulations, games and applications.
  EOT
  s.authors     = ["Łukasz Pomietło"]
  s.email       = "oficjalnyadreslukasza@gmail.com"
  s.files       = [
    *Dir.glob('lib/**/*'),
    *Dir.glob('stuff/**/*'),
  ]
  s.homepage    = "https://github.com/lpogic/kredki"
  s.license       = "Zlib"
  s.required_ruby_version     = ">= 3.2.2"
  s.metadata = {
    "documentation_uri" => "https://github.com/lpogic/kredki/blob/main/doc/wiki/README.md",
    "homepage_uri" => "https://github.com/lpogic/kredki"
  }
end