require 'workarea/testing/teaspoon'

Teaspoon.configure do |config|
  config.root = Workarea::Theme::Engine.root
  Workarea::Teaspoon.apply(config)
end
