module Workarea
  module Theme
    class Engine < ::Rails::Engine
      include Workarea::Plugin
      isolate_namespace Workarea::Theme
    end
  end
end
