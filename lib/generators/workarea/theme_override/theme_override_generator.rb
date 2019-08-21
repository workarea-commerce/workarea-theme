require 'workarea/testing/engine'

module Workarea
  class ThemeOverrideGenerator < Rails::Generators::Base
    desc File.read(File.expand_path('USAGE', __dir__))

    def copy_storefront
      override_views
      override_styles
      override_javascripts
      commit_overrides
      puts 'Good to go! Your theme is ready for development!'
      puts "Don't forget to run the cleanup script when you're done."
    end

    private

    def override_views
      Rails::Generators.invoke('workarea:override', ['views', 'workarea/storefront'])
      Rails::Generators.invoke('workarea:override', ['layouts', 'workarea/storefront/application.html.haml'])
      Rails::Generators.invoke('workarea:override', ['layouts', 'workarea/storefront/checkout.html.haml'])
    end

    def override_styles
      Rails::Generators.invoke('workarea:override', ['stylesheets', 'workarea/storefront/base'])
      Rails::Generators.invoke('workarea:override', ['stylesheets', 'workarea/storefront/components'])
      Rails::Generators.invoke('workarea:override', ['stylesheets', 'workarea/storefront/settings'])
      Rails::Generators.invoke('workarea:override', ['stylesheets', 'workarea/storefront/typography'])
    end

    def override_javascripts
      Rails::Generators.invoke('workarea:override', ['javascripts', 'workarea/storefront/modules'])
      Rails::Generators.invoke('workarea:override', ['javascripts', 'workarea/storefront/templates'])
    end

    def commit_overrides
      if Rails.env.test?
        create_file 'lib/workarea/theme/override_commit', 'TEST'
      else
        `git add .`
        `git commit -m"Theme override commit"`
        sha = `git log -n 1 --format=%H`

        create_file 'lib/workarea/theme/override_commit', sha
        `git add lib/workarea/theme/override_commit`
        `git commit -m"Commit the override commit sha record"`
      end
    end
  end
end
