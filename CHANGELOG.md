Workarea Theme 1.1.0 (2018-11-13)
--------------------------------------------------------------------------------

*   Do not inject 3rd party dependencies within the gems.weblinc.com source block

    Splits the dependency array before injecting to ensure 3rd party gems are added to the gemfile within the correct scope

    THEME-7
    Jake Beresford

*   Add documentation for Themes including:

    * Using a theme in an application.
    * Gem vs. dev tool implementation patterns.
    * Developing a theme, including upgrades and maintenance.

    THEME-6
    Jake Beresford

*   Implement override for all storefront assets for theming

    * Add theme_template for creating new themes
    * Add theme_override generator to override all commonly themed files
    * Theme template includes theme cleanup raketask to complete new tooling workflow.
    * Use Rails::Generators.invoke to call workarea:override generators as this keeps the execution context from the caller, which includes workarea and allows the generators to run from a plugin.
    * Add instructions for new tooling to README
    * Update to use workarea-ci for bamboo

    THEME-5
    Jake Beresford



Workarea Theme v1.0.3 (2018-02-20)
--------------------------------------------------------------------------------

*   Update generator to output versions correctly

    * Dependencies with specified versions were not being output to the host application's gemfile correctly

    THEME-4
    Jake Beresford



Workarea Theme v1.0.2 (2018-02-13)
--------------------------------------------------------------------------------

*   Prevent running generator tests in the context of a theme

    * Update `running_in_gem?` method to ensure tests only run when the bogus theme is installed

    THEME-3
    Jake Beresford



Workarea Theme v1.0.1 (2018-02-02)
--------------------------------------------------------------------------------

*   Attempting to run a rake task from the generator caused issues in the test environment.

    * Removed calls to rake rake clobber assets and seed DB

    THEME-2
    Jake Beresford



Workarea Theme v1.0.0 (2018-02-01)
--------------------------------------------------------------------------------
*   Implement script for importing theme as starter store

    * Implement `starter_store` generator
    * Add tests for generator. Tests only run from within this gem, not a host app.
    * Add bogus theme to use in tests for generator
    * Update Workarea::Theme to be an active support concern, similar to Workarea::Plugin.
    * Workarea::Theme must be included in the Theme's engine.rb file in order to be registered as a Theme within the host application.
    * Update Workarea::Theme raise an error if multiple themes being installed.

    Jake Beresford
