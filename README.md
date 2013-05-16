# Pomodori

Pomodori is a command line [Pomodoro](http://www.pomodorotechnique.com) timer. There are no shortage of other options for command line clients or GUI clients and many of them make fine choices.

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

## Why not just use a stopwatch or egg timer?

If that's what works for you, fantastic. I'm specifically interested exploring the reporting angle.

## Prerequisites

- Ruby 1.9.3
- SQLite

## Nice to have

- Growl or Notification Center

## Installation

This is a complete command line application distributed as a gem. Install it with: 

    $ gem install pomodori

## Usage

TODO: Write usage instructions here

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
