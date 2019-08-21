require 'test_helper'
require 'generators/workarea/starter_store/starter_store_generator'

module Workarea
  class StarterStoreGeneratorTest < GeneratorTest
    tests Workarea::StarterStoreGenerator
    destination Dir.mktmpdir

    def self.running_in_gem?
      Workarea::Theme.installed.name == 'Workarea::BogusTheme'
    end

    if running_in_gem?
      setup do
        prepare_destination
        FileUtils.mkdir_p "#{destination_root}/config/initializers"
        create_gemfile
        create_application_config
      end

      def create_gemfile
        File.open "#{destination_root}/Gemfile", 'w' do |file|
          file.write <<~eos
            gem 'workarea-bogus_theme', path: '~/src/workarea-bogus-theme'
            source 'https://gems.weblinc.com' do

            end
          eos
        end
      end

      def create_application_config
        File.open "#{destination_root}/config/application.rb", 'w' do |file|
          file.write <<~eos
            module TestApp
              class Application < Rails::Application

              end
            end
          eos
        end
      end

      def test_importing_app_files
        run_generator
        assert_file 'app/views/layouts/workarea/storefront/bogus.html.haml'
      end

      def test_importing_initializers
        run_generator
        assert_file 'config/initializers/theme.rb'
      end

      def test_loading_helpers
        run_generator
        assert_file 'config/application.rb' do |app_config|
          assert_match('config.to_prepare do', app_config)
          assert_match('BogusThemeHelper', app_config)
        end
      end

      def test_theme_commented_out_in_gemfile
        run_generator

        assert_file 'Gemfile' do |gemfile|
          assert_match("# gem 'workarea-bogus_theme'", gemfile)
        end
      end

      def test_dependencies_added_to_gemfile
        run_generator

        assert_file 'Gemfile' do |gemfile|
          assert_match("gem 'workarea-clothing'", gemfile)
          assert_match("gem 'workarea-blog', '>= 3.2.0'", gemfile)
        end
      end
    end
  end
end
