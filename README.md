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
- SQLite3
- Sequel

I'm writing this on OS X Mountain Lion, so I'm also expecting things like Notification Center. NB: Mountain Lion and earlier releases of OS X use an older version of Ruby. You'll need to update that to a later version. To do that (and install some of this software), you'll need developer tools installed.

## Installation

This is a complete command line application distributed as a gem. Install it with: 

    $ gem install pomodori

## Usage

Everything with Pomodori starts with the command `pmd`. Use `pmd help` to see what's available.

Once you install Pomodori, you should run the setup command.

    $ pmd setup

This will get you started with a config file (pomodori.yml) and a database file (pomodori.sqlite3). You can find those in $HOME/.pomodori.

To start a new pomodoro with a default summary, run:

    $ pmd start
    
You can also specify a specific summary:

    $ pmd start -s "Defining Pomodori usage"

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Make your changes, adding tests as appropriate
4. Make sure tests pass cleanly (`rspec`)
5. Commit your changes (`git commit -am 'Add some feature'`)
6. Push to the branch (`git push origin my-new-feature`)
7. Create new Pull Request
