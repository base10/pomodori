source 'https://rubygems.org'

# Specify your gem's dependencies in pomodori.gemspec
gemspec

# The following gems are needed run the test suite.
# Technically, RSpec is the *only* necessary one.
# guard, spork and others are "nice to have"

gem "rspec",        '~> 3.1.0'
gem "simplecov",    require: false
gem "factory_girl"
gem "guard-bundler"
gem "guard-rspec"
gem "guard-spork"
gem "awesome_print"
gem "pry-byebug"

gem 'terminal-notifier-guard'
gem "rb-fsevent", :require => false if RUBY_PLATFORM =~ /darwin/i
