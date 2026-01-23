module Kredki
  VERSION = "0.1.0"
end

Gem::Specification.new do |s|
  s.name        = "kredki"
  s.version     = Kredki::VERSION
  s.summary     = "A compact Ruby GUI toolkit."
  s.description = <<~EOT
    
  EOT
  s.authors     = ["Łukasz Pomietło"]
  s.email       = "oficjalnyadreslukasza@gmail.com"
  s.files       = [
    *Dir.glob('lib/**/*'),
    *Dir.glob('stuff/**/*'),
  ]
  s.homepage    = "https://github.com/lpogic/kredki"
  s.license       = "Zlib"
  s.required_ruby_version     = ">= 3.3"
  s.metadata = {
    "documentation_uri" => "https://github.com/lpogic/kredki/blob/main/doc/wiki/README.md",
    "homepage_uri" => "https://github.com/lpogic/kredki"
  }
end