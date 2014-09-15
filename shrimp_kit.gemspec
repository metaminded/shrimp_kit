Gem::Specification.new do |s|
  s.name        = 'shrimp_kit'
  s.version     = '0.0.1'
  s.date        = '2014-09-01'
  s.summary     = "ShrimpKit is a basic html renderer for Prawn"
  s.description = "ShrimpKit is a basic html renderer for Prawn."
  s.authors     = ["Peter Horn"]
  s.email       = 'ph@metaminded.com'
  s.files       = Dir["{lib}/**/*", "MIT-LICENSE", "README.md"]

  s.homepage    =
    'http://github.com/metaminded/shrimp_kit'
  s.license       = 'MIT'

  s.add_dependency "prawn",           ">= 1.2.0"
  s.add_dependency "prawn-table",     ">= 0.1.1"
  s.add_dependency "active_support",  ">= 4.0.0"
  s.add_dependency "csspool",         ">= 4.0.0"
end
