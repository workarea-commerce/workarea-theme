require 'workarea/bogus_theme'

module Workarea
  module BogusTheme
    class Engine < ::Rails::Engine
      include Workarea::Plugin
      include Workarea::Theme
      isolate_namespace Workarea::BogusTheme
    end
  end
end
