$LOAD_PATH.push File.expand_path('lib', __dir__)

# Maintain your gem's version:
require 'workarea/theme/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'workarea-theme'
  s.version     = Workarea::Theme::VERSION
  s.authors     = ['Curt Howard']
  s.email       = ['choward@workarea.com']
  s.homepage    = 'https://github.com/workarea-commerce/workarea-theme'
  s.summary     = 'Theme tooling for Workarea Commerce Platform'
  s.description = 'Tools and generators for working with themes on the Workarea Commerce Platform'

  s.files = `git ls-files`.split("\n")

  s.license = 'Business Software License'

  s.add_dependency 'workarea', '~> 3.x'
end
