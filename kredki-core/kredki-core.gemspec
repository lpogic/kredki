module Kredki
  VERSION = "0.1.0"
end

Gem::Specification.new do |s|
  s.name        = "kredki-core"
  s.version     = Kredki::VERSION
  s.summary     = "Ruby DSL for drawing - core only"
  s.description = <<~EOT
  EOT
  s.authors     = ["Łukasz Pomietło"]
  s.email       = "oficjalnyadreslukasza@gmail.com"
  s.files       = Dir.glob('lib/**/*')
  s.homepage    = "https://github.com/lpogic/kredki"
  s.license       = "Zlib"
  s.required_ruby_version     = ">= 3.2.2"
  s.add_runtime_dependency("fiddle", "~> 1.1")
  s.add_runtime_dependency("modeling")
  s.add_runtime_dependency("procify", "~> 0.1")
  s.metadata = {
    "documentation_uri" => "https://github.com/lpogic/kredki/blob/main/doc/wiki/README.md",
    "homepage_uri" => "https://github.com/lpogic/kredki"
  }
end