require 'workarea/testing/teaspoon'

Teaspoon.configure do |config|
  config.root = Workarea::BogusTheme::Engine.root
  Workarea::Teaspoon.apply(config)
end
