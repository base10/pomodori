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
- I've been thinking on how to both notify the user of milestones of their progress and to mark events as complete when they finish. Here's what I'm thinking:
    - When an event begins, the following notifications are created:
        - Notify at the beginning
        - Notify halfway (only for Pomodori)
        - Notify five minutes to go (only for Pomodori)
        - Notify complete
            - Notify complete triggers completion
    - A pid is saved to keep more than one process from running at a time
        - NB: Pomodori can be specified or terminated, reports can also be run, but only one Pomodori or Pausa can be live at one time
    - A process is marked to sleep for the amount of time until the next Notification is due
    - When the process wakes up, the notification is completed
        - How does that happen?
    - When the Event itself is marked complete or incomplete, the Notifications for that Event are removed from the database
    - When an Event is resolved, the pid is removed and the process exits
    - I am, as yet, uncertain about retaining the process and beginning a second (or third) Event. I'll leave that for a later determination. I would like to have a Pomodoro be followed by the appropriate Pausa. I don't see having everything chained, however.
    - Alternately, I can use "at" as the mechanism and have it check against active Events and Notifications
        - Downside of using at is that OS X users would have to enable at to work on their systems
    - Either approach will work. I'm going to start with the first one and see how it does
- I checked out a lot of [background job handlers](https://www.ruby-toolbox.com/categories/Background_Jobs) and Sidekiq stuck out. However, I don't like having a dependency on redis. Two potential options:
    - [rufus-scheduler](https://github.com/jmettraux/rufus-scheduler)
        - Likely pick
    - [later](https://github.com/Erol/later)
    - [Clockwork](https://github.com/tomykaira/clockwork)
    - Other options might be helpful when we get to crunching reports
        - delayed\_job
        - sucker\_punch
        - qu
- It looks like a state machine will also be helpful
    - [transitions](https://github.com/troessner/transitions)
        - On a quick read, this is the DSL I like best, starting here
    - [workflow](https://github.com/geekq/workflow)
    - [AASM](https://github.com/aasm/aasm)
    - [state_machine](https://github.com/pluginaweek/state_machine)
    - [micromachine](https://github.com/soveran/micromachine)
- Messages + Receivers
    - Events
        - begin
            - check_for_live_events
            - build_notifications
            - set_started_at
            - fork_notification_process
- TODO: Model the state diagram for events
- TODO: Write rules for the state machine
- TODO: pmd (the CLI application) should be non-blocking

## 2013-09-02

- Began work on implementing the state machine
- My approach is going to be get the walking skeleton of the state machine done, then layer on object saving, validating transition states and handling notifications
- Once the state machine is fully implemented, I'll add the Event-specific durations

## 2013-09-03

- Working with Sequel, it doesn't seem like Transitions is compatible
- Looking around, there's a [plugin for Workflow and Sequel](http://jackchu.com/blog/2013/01/18/state-machines-with-the-workflow-gem/), so I'm going to give that a shot

## 2013-09-28

- Yeah, been a while. Work's been crazy busy the last few weeks
- workflow and workflow_sequel_adaptor seem to expect a :states column. It's
  not terribly obvious which.
- Based on a suggestion seen on http://jackchu.com/blog/2013/01/18/state-machines-with-the-workflow-gem/
  I'm going to try the transitions gem again with an ActiveModel plugin
- I'm still hoping to avoid going to state_machine since that seems like
  a much larger hammer than I need

## 2013-10-07

- Taking the approach of trying transitions and workflow gems separately in two branches, issue-11 and issue-11-workflow respectively

## 2013-10-09

- transitions has not worked out, running into the same problem as jackchu mentioned
- Next: Try to get a local version of workflow installed
- Workflow again has not worked out. Looking at micromachine
    - See issue-11-micromachine branch

## 2013-10-11

- MicroMachine seems to be fitting the bill

## 2013-10-14

- Sure enough, MicroMachine took care of what I needed it to. Closed issue-11 on GitHub.
    - issue-11 and issue-11-workflow branches are dead
- Moving on to thinking though notifications
    - See doc/code-brainstorming/notifications.md for more information
- TODO: Make sure notification object doesn't have a recursion problem when showing an assoc. with event
- I want to separate the defining of notifications, when they need to be delivered from the mechanism that delivers them, so I'm going to add a notifier_strategy
    - The notifier should be instantiated lazily
- Strategies to implement
    - Mac OS X Terminal Notifier
    - Test STDOUT
- Later, possible strategies
    - Growl
    - Linux-based
- As for the notification itself, I want to have subclasses for each type to specify message and title

## 2013-10-17

- Brought in associations for event and notification objects
- Adding notification message and title tests as a start, until I start subclassing
- Going to start modeling notification strategies

## 2013-10-19

- Writing two sets of strategy patterns
    - First is from Notification, calling deliver, which calls get_strategy to read the config and determine which notifier to use
    - Second, I build an initializer for Notification, using #action to return the right class
- Strategy pattern seems to apply to Pausa and LungaPausa classes, too. I'll need a of some sort to hand back the right object from Pomodoro
- A side-effect of the work I'm doing on Notification might be to simplify how I use Setup and Config.
    - Create a proper base object, move the instantiation pieces there.
    - Config becomes a singleton (Confident Ruby, search for module\_function)
    - Setup becomes a true service object


## 2013-10-26

- Reviewing where I'm at, since I've not touched code in a week.

## 2013-10-27

- So, thinking about Setup and Config, I could use a null object for cases when there's not a config file or database in place. That will help with the initial setup and with testing.

