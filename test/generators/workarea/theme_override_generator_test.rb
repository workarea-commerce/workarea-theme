require 'test_helper'
require 'generators/workarea/theme_override/theme_override_generator'

module Workarea
  class ThemeOverrideGeneratorTest < GeneratorTest
    tests Workarea::ThemeOverrideGenerator
    destination Dir.mktmpdir

    def self.running_in_gem?
      Workarea::Theme.installed.name == 'Workarea::BogusTheme'
    end

    if running_in_gem?
      setup :prepare_destination

      def test_copying_files
        run_generator

        assert_file 'lib/workarea/theme/override_commit'
      end
    end
  end
end
