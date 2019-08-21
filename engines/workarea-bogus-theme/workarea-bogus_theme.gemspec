$LOAD_PATH.push File.expand_path('lib', __dir__)

# Maintain your gem's version:
require 'workarea/bogus_theme/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'workarea-bogus_theme'
  s.version     = Workarea::BogusTheme::VERSION
  s.authors     = ['Jake Beresford']
  s.email       = ['jberesford@weblinc.com']
  s.homepage    = 'http://www.workarea.com'
  s.summary     = 'BogusTheme for testing theme functionality'
  s.description = 'Totally fake theme, dude.'

  s.files = `git ls-files`.split("\n")

  s.add_dependency 'workarea', '~> 3.x'
  s.add_dependency 'workarea-blog', '>= 3.2.0'
  s.add_dependency 'workarea-clothing'
  s.add_dependency 'workarea-theme'
end
