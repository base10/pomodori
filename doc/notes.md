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

## 2013-07-14

- Building validations and tests for Pomodori
    - Having path problems

## 2013-07-06

Ideally, addressing last pieces of having environments do the right thing.

- Looking at the tests, it looks like I'm expecting the setup object to know about accessors that _other_ objects are setting. That's no good. Found out that I wasn't setting the environment in the Setup object
- Updated config file, tweaked matchers
- Should resolve Issue #4

## 2013-07-21

- Added several issues recently on the GitHub project
- Fixed up getting bin/pmd to work

## 2013-08-03

I have discovered a flaw in my thinking of having Pomodori::Configure be a composable module with an initialize method. Namely, when I get to having a Configure object be part of the object when I am also using Sequel::Model, I'm not getting Sequel::Model's initialize method. I can fix this by using database's configure object, but this seems like I'm violating encapsulation.

My other thought is to make Configure a singleton. I need to think about that more. In the meantime, I'm going to pragmatically press ahead with a FIXME to revisit this and make forward progress. Opened as Issue #8

I also had to fix up issues with the factories and not having a created_at field in the first migration.

## 2013-08-21

Finally got object validation working with a created_at date. Had to learn a bit about how Sequel::Model instance values are represented.

## 2013-08-22

- Durations should be set at initialization from the available config. Later on, I may want to allow a CLI-defined duration
- I need to think through how states advance and arrive at completion / incompletion. Flow diagram likely to be helpful.
- In code, state might be represented with a constant hash and a method like "next_action" that acts on begin, mark_complete and so on. Or, might be flipped so that the action methods act on state (more likely). Key will be making sure methods only act if they *can* act.

## 2013-08-24

Trying to set default values and running into some test failures, which suggests a change in approach is needed. I'm fleshing out initialize for Pomodori::Pomodoro and I'll then abstract it back into Pomodori::Event

## 2013-08-31

- [x] TODO: Move String class monkey patching into separate file, [document source](http://stackoverflow.com/questions/1509915/converting-camel-case-to-underscore-case-in-ruby)
