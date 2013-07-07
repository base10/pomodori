# Dev Notes

## Purpose

This acts as a dev notebook for work on the Pomodori gem.

## 2013-06-xx: Trouble with getting Pomodori::Config and Pomodori::Event

I want to see if ignoring Pomodori::Config in the spec_helper will move me past the problem. Then and only then, I'll add a backstop method to Pomodori::Config. That might involve some refactoring from Pomodori::Setup.

Tried the above, sadly, it doesn't look like it's going to work, so onto doing something different.

- Mock the file in spec_helper, proceed with an in-memory db?
- Backstop method in Pomodori::Config

## 2013-06-17

- I can instantiate the database with Pomodori::Config, but I suspect I'm not getting a fresh instance when I call "new"
- When calling FactoryGirl, I'm instantiating the object, but not getting a config. Maybe the config gets defined in a Factory, too?

## 2013-06-19

Giving Pomodori::Event information about the table Sequel::Model should expect to work against and testing is a bit of pain, particularly if I expect that I don't have a database. I was hoping to present a good bootstrapping experience and have that tested on every run, but it seems like that's not a good thing to expect. That would involve having to do a lot more magic in spec_helper that I probably shouldn't be doing.

A brief divergence into what I shouldn't be doing:

- Have spec_helper.rb require each file under lib, as it does now
- rescue Sequel::DatabaseConnectionError *and*, bonus crazy, run the database migrations against a temp sql file

What I should do instead:

- Take the Ruby on Rails approach of expecting set-up to be done ahead of testing with a database present
- Continue on with building Event and Pomodori models

## 2013-06-22

Beginning work setting up a test database as noted above.


## 2013-07-06

Ideally, addressing last pieces of having environments do the right thing.

- Looking at the tests, it looks like I'm expecting the setup object to know about accessors that _other_ objects are setting. That's no good. Found out that I wasn't setting the environment in the Setup object
- Updated config file, tweaked matchers
- Should resolve Issue #4
