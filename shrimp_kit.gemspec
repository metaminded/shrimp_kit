Gem::Specification.new do |s|
  s.name        = 'ShrimpKit'
  s.version     = '0.0.1'
  s.date        = '2014-09-01'
  s.summary     = "ShrimpKit is a basic html renderer for Prawn"
  s.description = "ShrimpKit is a basic html renderer for Prawn."
  s.authors     = ["Peter Horn"]
  s.email       = 'ph@metaminded.com'
  s.files       = ["lib/shrimp_kit.rb"]
  s.homepage    =
    'http://github.com/metaminded/shrimp_kit'
  s.license       = 'MIT'

  s.add_dependency "prawn",       ">= 0.12.0"
  s.add_dependency "actionpack",  ">= 4.0.0"
end
