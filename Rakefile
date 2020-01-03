#!/usr/bin/env rake
begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

require 'rdoc/task'

RDoc::Task.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'Theme'
  rdoc.options << '--line-numbers'
  rdoc.rdoc_files.include('README.md')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

APP_RAKEFILE = File.expand_path('test/dummy/Rakefile', __dir__)
load 'rails/tasks/engine.rake'
load 'rails/tasks/statistics.rake'
load 'workarea/changelog.rake'

require 'rake/testtask'

Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = false
end
task default: :test

$LOAD_PATH.unshift File.expand_path('lib', __dir__)
require 'workarea/theme/version'

desc "Release version #{Workarea::Theme::VERSION} of the gem"
task :release do
  host = "https://#{ENV['BUNDLE_GEMS__WEBLINC__COM']}@gems.weblinc.com"

  Rake::Task['workarea:changelog'].execute
  system 'git add CHANGELOG.md'
  system 'git commit -m "Update CHANGELOG"'

  system "git tag -a v#{Workarea::Theme::VERSION} -m 'Tagging #{Workarea::Theme::VERSION}'"
  system 'git push origin HEAD --follow-tags'

  system 'gem build workarea-theme.gemspec'
  system "gem push workarea-theme-#{Workarea::Theme::VERSION}.gem"
  system "gem push workarea-theme-#{Workarea::Theme::VERSION}.gem --host #{host}"
  system "rm workarea-theme-#{Workarea::Theme::VERSION}.gem"
end

desc 'Run the JavaScript tests'
ENV['TEASPOON_RAILS_ENV'] = File.expand_path('test/dummy/config/environment', __dir__)
task teaspoon: 'app:teaspoon'

desc 'Start a server at http://localhost:3000/teaspoon for JavaScript tests'
task :teaspoon_server do
  Dir.chdir('test/dummy')
  teaspoon_env = File.expand_path('test/teaspoon_env.rb', __dir__)
  system "RAILS_ENV=test TEASPOON_ENV=#{teaspoon_env} rails s"
end
