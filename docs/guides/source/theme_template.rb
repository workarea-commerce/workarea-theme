# Start with...
# rails plugin new path/to/my_theme --full -m path/to/theme_template.rb --skip-spring --skip-active-storage --skip-action-cable
#
# Or using the Workarea CLI
# workarea new theme path/to/my_theme
#

def source_paths
  ["#{Gem::Specification.find_by_name('workarea').gem_dir}/docs/guides/source/"]
end

apply('plugin_template.rb')

# Add workarea-theme as a dependency
workarea_theme_dependency = "s.add_dependency 'workarea-theme', '~> 1.x'\n"
inject_into_file "workarea-#{name}.gemspec", workarea_theme_dependency, before: "end\n"

# require workarea/theme in plugin libfile
insert_into_file "lib/workarea/#{name}.rb", "require 'workarea/theme'\n", after: "require 'workarea/admin'\n"

# include Workarea::Theme in engine
insert_into_file "lib/workarea/#{name}/engine.rb", "      include Workarea::Theme\n", after: "include Workarea::Plugin\n"

create_file 'config/initializers/theme.rb', <<~CODE
  Workarea.configure do |config|
    config.theme = {
      color_schemes: ['#{name}'],
      color_scheme: '#{name}',
      font_stacks: {
        sans_serif: 'sans-serif',
        serif: 'serif'
      },
      primary_font_family: 'sans_serif',
      secondary_font_family: 'serif'
    }
  end
CODE

create_file 'app/assets/stylesheets/workarea/storefront/settings/_font_families.scss.erb', <<~CODE
  /*------------------------------------*\\
      #FONT-FAMILIES
  \\*------------------------------------*/

  <%= "$font-family: \#{Workarea.config.theme[:font_stacks][Workarea.config.theme[:primary_font_family].to_sym]} !default;" %>
  <%= "$secondary-font-family: \#{Workarea.config.theme[:font_stacks][Workarea.config.theme[:secondary_font_family].to_sym]} !default;" %>
CODE

create_file 'app/assets/stylesheets/workarea/storefront/settings/_colors.scss.erb', <<~CODE
  /*------------------------------------*\\
      #COLORS
  \\*------------------------------------*/

  /**
   * Color Variables
   *
   * These variables are loaded in from the theme's color scheme configurations
   *
   * To customize colors in this theme you can add your own color scheme
   * file to the storefront/theme_config directory and reference
   * it by name below.
   */

  <% path = "\\'workarea/storefront/theme_config/color_schemes/\#{Workarea.config.theme[:color_scheme].downcase}_color_scheme\\';" %>

  <%= "@import \#{path}" %>
CODE

create_file "app/assets/stylesheets/workarea/storefront/theme_config/color_schemes/#{name}_color_scheme.scss.erb", <<~CODE
  /*------------------------------------*\\
      ##{name.upcase.dasherize}-COLOR-SCHEME
  \\*------------------------------------*/
  /**
   * Color Variables
   *
   * These variables should always be aliased as Functional Variables at
   * the bottom of this file. Using color name variables outside of this file may
   * cause errors when changing color scheme.
   */

  $blue:                              #3366cc !default;
  $yellow:                            #fdcc5d !default;
  $red:                               #b50010 !default;
  $green:                             #19c06a !default;

  $white:                             #ffffff !default;
  $gray:                              #666666 !default;
  $light-gray:                        #dddddd !default;
  $black:                             #000000 !default;

  $black-alpha-15:                    rgba($black, 0.15) !default;
  $black-alpha-50:                    rgba($black, 0.50) !default;

  $white-alpha-50:                    rgba($white, 0.50) !default;

  $transparent:                       transparent !default;





  /**
  * Brand Color Variables
  */





  /**
  * Global Functional Color Variables
  */

  $font-color:        $black !default;
  $background-color:  $white !default;
  $highlight-color:   $yellow !default;
  $link-color:        $blue !default;

  $overlay-shadow-color:  $black-alpha-15 !default;

  $focus-ring-color:  $blue !default;
CODE

# Add theme_cleanup rake task
rakefile('theme_cleanup.rake') do
  <<~TASK
    namespace :workarea do
      desc 'Initial setup for installation'
      task theme_cleanup: :environment do
        puts 'Cleaning up your theme for release!'
        original_sha = File.read('./lib/workarea/theme/override_commit').strip
        changed_files = `git diff --name-only HEAD \#{original_sha}`.split("\\n")

        # Remove any files that are unchanged since the original commit SHA
        # Reverse each to remove files within directories before attempting to delete the dir
        Dir['app/**/*'].reverse_each do |path|
          next if changed_files.include?(path)

          if File.directory?(path)
            Dir.rmdir path if Dir.entries(path).size == 2
          else
            File.delete(path)
          end
        end
      end
    end
  TASK
end

#
# Load theme_cleanup in Rakefile
#
append_to_file 'Rakefile', <<~CODE

  load 'lib/tasks/theme_cleanup.rake'
CODE
