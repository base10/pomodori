# Pomodori

Pomodori is a command line [Pomodoro](http://www.pomodorotechnique.com) timer. There is no shortage of other options for either command line or GUI clients. Many of them make fine choices.

I am writing Pomodori because I want something a little bit different than what I've seen when trying out the other clients, namely:

- Reporting
    - Pomodori completed in a day
    - Pomodori completed in the last work week
    - Some extended report formatting options
- Better control over how much I had to set-up in terms of defining tasks or naming pomodori
- Ability to adjust the "rules" of Pomodoro
    - More fine-grained control over the length of a *pomodoro* (default 25 minutes)
    - The length of a break between *pomodori* (default 5 minutes)
    - The size of a set of pomodori (default 4 pomodori)
    - The break between pomodori sets (default 15 minutes)

## Why not just use a stop watch or egg timer?

As a GTD practitioner, I sometimes find myself flailing at being productive. So, I'm looking to tie tasks I work on with time I spend "focused." I'm specifically interested exploring the reporting angle.

That said, if you get what you need working with a stop watch or other timing mechanism (or no mechanism at all), my proverbial hat is off to you.

## Prerequisites

- Ruby 1.9.3
- SQLite
- Sequel

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
