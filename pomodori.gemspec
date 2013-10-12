# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pomodori/version'

Gem::Specification.new do |spec|
  spec.name          = "pomodori"
  spec.version       = Pomodori::VERSION
  spec.authors       = ["Nathan L. Walls"]
  spec.email         = ["nathan@wallscorp.us"]
  spec.description   = %q{
Pomodori is a command line Pomodoro timer. There are no shortage of other options for command line clients or GUI clients and many of them make fine choices.

I am writing Pomodori because I want something a little bit different than what I've seen when trying out the other clients, namely:

- More fine-grained control over the length of a *pomodoro* (default 25 minutes)
- The length of a break between *pomodori* (default 5 minutes)
- The size of a set of pomodori (default 4 pomodori)
- The break between pomodori sets (default 15 minutes)
- Better control over how much I had to set-up in terms of defining tasks or naming pomodori
- Reporting
    - Pomodori completed in a day
    - Pomodori completed in the last work week
    - Some extended report formatting options
  }
  spec.summary       = %q{A command line pomodoro timer with reporting}
  spec.homepage      = "https://github.com/base10/pomodori"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"

  spec.add_dependency "gli"
  spec.add_dependency "sqlite3"
  spec.add_dependency "terminal-notifier"
  spec.add_dependency "sequel"
  spec.add_dependency "micromachine"
end
