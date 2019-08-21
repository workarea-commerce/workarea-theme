require 'workarea/testing/engine'

module Workarea
  class StarterStoreGenerator < Rails::Generators::Base
    desc File.read(File.expand_path('USAGE', __dir__))

    def theme_import
      @theme = Workarea::Theme.installed
      self.class.source_root(@theme.root)

      import_app_files
      update_gemfile
      import_initializers
      import_tests
      remove_theme_from_gemfile
      load_helpers
      bundle_install

      puts "#{@theme.homebase_name} imported successfully."
      puts 'You may need to run the assets:clobber rake task for changes to take effect.'
    end

    private

    def import_app_files
      puts 'Importing app files...'

      relative_path = 'app'
      directory(relative_to_original_destination_root(relative_path), relative_path)
    end

    def import_initializers
      puts 'Importing initializers...'

      relative_path = 'config'
      directory(relative_to_original_destination_root(relative_path), relative_path)
    end

    def load_helpers
      puts 'Loading helpers...'

      helpers = Dir["#{@theme.root}/app/helpers/**/*.rb"].map do |helper|
        file_name = helper.split('/').last.gsub('.rb', '')
        "Workarea::Storefront::ApplicationController.helper(Workarea::Storefront::#{file_name.camelize})\n".indent(2)
      end.join('')

      application do
        f = "config.to_prepare do\n"
        f << helpers.indent(4)
        f << "end\n".indent(4)
        f
      end
    end

    def import_tests
      puts 'Importing tests...'

      relative_path = 'test'
      directory(relative_to_original_destination_root(relative_path), relative_path, exclude_pattern: 'dummy/*|teaspoon_env.rb|test_helper.rb')
    end

    def remove_theme_from_gemfile
      puts 'Commenting out theme from gemfile...'
      comment_lines 'Gemfile', /#{@theme.slug}/
    end

    def update_gemfile
      puts 'Updating gemfile...'

      workarea_dependencies, other_dependencies = dependency_array.partition { |d| d[:name].include?("workarea") }

      inject_into_file 'Gemfile', after: "source 'https://gems.weblinc.com' do\n" do
        workarea_dependencies.map do |dependency|
          if dependency[:requirement] == '>= 0'
            "gem '#{dependency[:name]}'\n"
          else
            "gem '#{dependency[:name]}', '#{dependency[:requirement]}'\n"
          end
        end.join('').indent(2)
      end

      inject_into_file 'Gemfile', before: "source 'https://gems.weblinc.com' do\n" do
        other_dependencies.map do |dependency|
          if dependency[:requirement] == '>= 0'
            "gem '#{dependency[:name]}'\n"
          else
            "gem '#{dependency[:name]}', '#{dependency[:requirement]}'\n"
          end
        end.join('')
      end
    end

    def dependency_array
      dependencies_from_gemspec.delete_if do |d|
        d[:name].in?(dependencies_from_gemfile) || d[:name] == 'workarea-theme'
      end.sort_by { |d| d[:name] }
    end

    def dependencies_from_gemspec
      gemspec_path = "#{@theme.root}/workarea-#{@theme.slug}.gemspec"
      dependencies = Gem::Specification.load(gemspec_path).dependencies

      dependencies.map do |dependency|
        {
          name: dependency.name,
          requirement: dependency.requirements_list.join('')
        }
      end.compact
    end

    def dependencies_from_gemfile
      File.readlines('Gemfile').map do |line|
        next unless line.include?('gem')
        next if line.include?('#') || line.include?('gems.weblinc') || line.include?('rubygems')
        line.chomp.strip.split(',').first.split("'").last
      end.compact
    end

    def bundle_install
      puts 'Installing new gems...'
      run('bundle install', verbose: false)
    end
  end
end
