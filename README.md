# Workarea Theme

This plugins provides infrastructure for theme development and use on the Workarea platform.

## Workarea Themes

A Workarea theme is a specialized type of Workarea plugin.
Themes specifically customize the appearance of the Workarea platform.
Themes allow for re-use of storefront code, helping to jump-start front-end work
for an implementation.
A theme may be used as a starting point for front-end development, or as a
complete storefront UI.

## Installing a theme in a Workarea application

Installing a theme in a Workarea application is like installing any other plugin.
Add the theme's gem to your application's gemfile:

```ruby
  source 'https://gems.weblinc.com' do
    gem 'workarea-your_theme_name'
  end
```

Then run `bundle install` and restart your application.

Some themes may need extra configuration. Check the README.md for the theme you
are using to see if any further configuration is necessary.

## Configuring a theme

All themes include a `config/initializer/theme.rb` file, which provides options
for configuration within the Workarea application.
Typically themes allow configuration for color schemes and font families.

An example of a Workarea theme configuration file:

```ruby
Workarea.configure do |config|
config.theme = {
  color_schemes: ["one", "workarea", "midnight"],
  color_scheme: "one",
  font_stacks: {
    roboto: '"Roboto", "HelveticaNeue", "Helvetica Neue", sans-serif',
    lora: '"Lora", "Times New Roman", "Georgia", serif',
    hind: '"Hind", Helvetica, Arial, sans-serif',
    source_serif_pro: '"Source Serif Pro", "Times New Roman", Georgia, serif',
    muli: '"Muli", Helvetica, Arial, sans-serif',
    playfair_display: '"Playfair Display", "Times New Roman", Georgia, serif'
  },
  primary_font_family: "roboto",
  secondary_font_family: "lora"
}
end
```

## Approaches to using a theme

There are 2 ways to use a Workarea theme.

1. Installing the theme as a gem in your application, similar to other plugins.
2. As a development tool by running the `starter_store` generator to import a
    theme's files to your application.

### Gem vs. Development tool approach

Using a Workarea theme as a gem is the quickest way to apply a theme to a Workarea
application. The benefit of running a theme as a gem is getting bug-fixes and upgrades
from the theme in patch releases.

Using a theme as a development tool is an alternative way to use a Workarea theme.
Rather than running the theme as a plugin; all of the theme's files, dependencies,
and configurations are copied in to your application. This is done by running the
`starter_store` generator from your host application. This approach allows greater
flexibility in development, however it removes you from the direct upgrade path
for the theme. This means you will need to use the Workarea upgrade tool to apply
patches and upgrades as they are released for the theme.

The development tool approach is most useful if:

- You plan to customize the application heavily using the theme as a starting point.
- You need to remove a dependency of the theme.
  - For example a theme may depend on workarea-reviews, but your implementation uses
    a 3rd party review system. The only way to use a theme and remove one of its
    dependencies is by installing the theme using the `starter_store` generator.

### Using a theme as a development tool

To prepare for installing a theme as a starter store you must add the theme to
your application gemfile and run `db:seed`. Once you have the theme running in your
application run the `starter_store` generator

```bash
bundle exec rails g workarea:starter_store
```

During the execution of this generator you will be prompted to make decisions
re. overriding existing files in your application. Use the Ynaqdh interface
to make decisions on a per-file basis. I have found that 'n' is typically the
preferable choice, with the exception of locales/en.yml

After the generator is run you should:

1. Run bundle install.
2. Confirm that your application is running and is styled as expected.
3. Remove the now commented-out theme from your gemfile.
4. Run the full test suite and ensure nothing is failing.
5. Commit your changes and open a pull-request.

#### Appended files

Appends, and append removals will still be handled via the imported appends.rb
initializer. It is recommended that you review the contents of this file and
update your host application where appropriate to include these appended files
as normal, removing them from appends.rb. This is especially advisable for Sass
and JS assets which can easily be added to your application manifests.

## Upgrading a themed application

If you have installed your theme using the `starter_store` generator the upgrade
path is the same as any other application. Be sure to use the [Workarea upgrade tool](https://stash.tools.weblinc.com/projects/WL/repos/workarea-upgrade/browse) when
upgrading your application

If your application is using a theme as a plugin you should follow these steps:

1. Check whether your theme has already been upgraded for compatibility with the
    version of Workarea you are upgrading to.
    - If the theme is not yet upgraded contact the theme developer and find out
    when that will be complete. It is not recommended to upgrade your application
    until the theme is ready.
2. Upgrade Workarea and all other plugins first, use the Workarea upgrade tool to
    create a diff and make the necessary changes in your application.
3. Update the theme's version in your gemfile to use the latest version that is
    compatible with your new Workarea version.
4. Run the upgrade tool against your theme to see if there are further changes
    that need to be made to files that have been overridden in your application.

Once all necessary changes highlighted in the diff have been made, tests are
passing, and your PR has been accepted, your application is upgraded and should
be sent to QA for testing. Drink a beer, you've earned it!

## Multisite support for themes

Multisite applications are able to use Workarea themes without many changes to
the normal multi-site development workflow.

Configuration options set in theme.rb should be applied to each instance of
Workarea::Site, this allows you to easily apply different color schemes and fonts
to each site with minimal effort. Skinning a new site for a themed multi-site app
should be relatively simple!

It is not possible to use more than 1 theme per application. This means you cannot
use different themes for different sites within a multi-site application. All sites
must be based on the same theme, but each can customize away from the theme as necessary.
Follow the [instructions for working with multi-site applications](https://stash.tools.weblinc.com/projects/WL/repos/workarea-multi-site/browse)
for more information about developing multi-site applications.

## Developing a new Workarea Theme

To create a Workarea theme use the _rails plugin new_ command with the Workarea
theme template. Follow the instructions for using the [app template](https://developer.workarea.com/workarea-3/guides/app-template),
with the following changes.

- Use _rails plugin new_ instead of _rails new_
- Use the path to _theme\_template.rb_ (instead of _app\_template.rb_) as the
    argument to the _--template_ option
- Include the _--full_ option when running _rails plugin new_

After creating the theme, edit the gemspec file to set relevant metadata.

Alternatively you may use the Workarea CLI to run the new theme generator, if you
have the CLI tool installed you can run

```bash
workarea new theme path/to/my_theme
```

### Theme development workflow

Once you've created your theme engine and edited the gemspec you can start
developing your theme. Theme development relies heavily on overriding views,
stylesheets, and javascripts from Workarea Storefront. To jump-start your theme
development run the theme override generator to override all of the files you're
likely to need in your theme.

To use the theme override generator run

```bash
bin/rails generate workarea:theme_override
```

This will override every view file, along with most Sass and JS files from
workarea-storefront. The generator also commits these overrides and stores the
commit SHA in `lib/workarea/theme/override_commit`. This file is used by the
Workarea `theme_cleanup` rake task and should not be deleted.

Having overridden most of the files you will need to develop your theme, you are
now ready to start implementing your designs. Should you need to override other
files from Storefront, or another plugin, you should use the [Workarea override
generator](https://developer.workarea.com/workarea-3/guides/overriding).

Once you have implemented your theme you should run the Workarea `theme_cleanup` rake
task. This will remove any files in `/app` that have not changed since you ran the
theme_override generator. To execute `theme_cleanup` run:

```bash
bin/rails workarea:theme_cleanup
```

Be sure to check the files that have been removed, and test that your theme runs
and looks correct before committing this change.

Once your theme is cleaned up you're done, congratulations! Now head over to the
[Workarea plugin documentation](https://developer.workarea.com/workarea-3/guides/plugins-overview)
to learn how to release your theme for use!

### Theme requirements

In order for your theme to be registered correctly within the host application it
must depend on workarea-theme and have the following include in your plugin's
engine.rb file:

```ruby
  include Workarea::Theme
```

This is necessary for the `starter_store` generator to work.

In addition your theme must:

- Include a theme.rb initializer.
- Allow the host application to configure the color scheme.
- Allow the host application to configure fonts.

The theme_template will take care of setting these things up for you, be sure to
follow the instructions for creating a new Workarea theme to ensure your theme is
configured properly.

It is recommended that your theme's README include the following information:

- Optimal image sizes.
- Compatible Workarea plugins and dependencies.
- Browser support, preferably supplemented with a browserlist file in the theme's
    root directory.
- Instructions for any additional configuration or features specific to your theme.

### Theme plugin dependencies

Your theme may include dependencies on other Workarea plugins. This allows you to
ship a theme with support for popular functionality out of the box, and to benefit
from pluginized UI components and functionality.

To add support for another plugin, first add it to your theme's gemspec like this:

```ruby
s.add_dependency 'workarea-swatches', '1.0.0'
```

Next you will need to override the relevant files from the plugin to your theme.
You should use the [workarea override generator](https://developer.workarea.com/workarea-3/guides/overriding) to do this.
Once you have overridden all of the necessary files you can adjust styles, markup,
and functionality as required to meet your requirements.

_Note:_ dependencies of a theme cannot be removed when using
the theme as a gem, so it is best to keep dependencies to a minimum. The only way
to remove a theme's dependencies within a host application is to use the `starter_store`
generator, then remove the unwanted dependency from the application gemfile along
with any related app files (views, styles etc.).

### Maintaining your theme

A theme is like a baby, you spend a while making one, then you have a lifetime
of taking care of it.

Maintaining your theme means fixing bugs as they come in, and keeping your theme
up to date with the latest versions of Workarea. If your theme is not kept up to
date you will cause great pain and sadness for developers that have used your theme
in their applications. You might prevent them from being able to take upgrades.

#### Upgrading for minor-version compatibility

Upgrading your theme for compatibility with Workarea is important. At a minimum
all themes should be upgraded with the latest changes in each new minor version
of Workarea.

To upgrade your theme follow these steps:

1. Read both the release notes on developer.workarea.com and the release announcement
    on discourse.
    - Discourse includes release notes for plugins, ensure any plugin dependencies
    are upgraded too!
2. Create a new host app to use for the upgrade.
3. Install your theme, seed the app, and make sure it’s running as expected.
4. Install the workarea-upgrade gem.
5. Use the `starter_store` generator to clone your theme in to your new host
    application.
6. Run the workarea_upgrade command, first checking the report for your upgrade,
    then generating a diff.
7. The upgrade report should help you estimate how much time your upgrade will take.
8. Step through your diff making all the necessary changes to your theme.
9. Load your theme and the latest version of Workarea in a different host app.
10. Ensure the app loads, resolve any errors you encounter.
11. Check every view that you changed as part of the diff.
12. If styles or JS functionality were changed or added you should ensure these
    are working as intended at this point.
13. Commit your changes and open a PR.

Good work soldier! Your Workarea theme is up-to-date. Once your PR is approved,
and changes pass QA you can release your theme's new minor version to the gem server.

## Copyright & Licensing

Copyright WebLinc 2018. All rights reserved.

For licensing, contact sales@workarea.com.
