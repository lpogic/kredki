module Kredki
  VERSION = "0.1.0"
end

Gem::Specification.new do |s|
  s.name        = "kredki"
  s.version     = Kredki::VERSION
  s.summary     = "Ruby DSL for drawing"
  s.description = <<~EOT
    Ruby DSL for drawing. Uses ThorVG for rendering and SDL for window managing and input handling.
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
  s.add_runtime_dependency("kredki-core", "~> 0.1")
  s.metadata = {
    "documentation_uri" => "https://github.com/lpogic/kredki/blob/main/doc/wiki/README.md",
    "homepage_uri" => "https://github.com/lpogic/kredki"
  }
end