<!-- -*- mode:markdown; x-soft-wrap-text:true; -*- -->

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
- First, get issue-12 resolved with notification delivery
- Then, address refactoring and issue-14

## 2013-10-29

- Backing out work on trying to mock File.read for a test, so just accepting what's coming from Configure

## 2013-10-31

- Finished issue-12
- Beginning on issue-14 (applying Confident Ruby lessons)

## 2013-11-29

- Config becomes a "parameter object" per Confident Ruby, instantiated and then passed
- Base methods move to a base module class
- Config set-up moves to a set of common examples
- Initial config file can be a class method on Pomodori::Configure

## 2013-11-30

I'm trying to think of how I can safely extract Pomodori::Configure and:

- Change it over to a class
- Get other classes to declare their own initialize
- Update calls to environment accordingly
    - Setup
    - Database
    - Make sure other changes propogate
    - Simplify the tests

## 2013-12-01

- Continuing on with work from Nov. 30

## 2013-12-20

Read something from Ben Scofield that projects shouldn't last more than a quarter and given how long this has been dragging on, yep.

## 2013-12-21

- Failing test for databases is in the wrong spot. Let configuration fail instead.
- I'm going to take another pass through the code to see if there's anything else needing refactoring, but that seems like a pretty start.
- Separate consideration, would it be worthwhile converting to ActiveRecord?
    - Based on Steven's notes at work about using ActiveRecord vs. Sequel and prevalence of use.
- What would make Notifier better as a base class vs. module?
    - Might await moving that around based on POODR reading

## 2014-01-07

- Added issue-23, although I think depending on how I structure reporting, I can avoid it.
- Looking at the [Sequel README](http://sequel.jeremyevans.net/rdoc/files/README_rdoc.html) and DateTime's available methods, implemented issue-13

## 2014-01-09

- Fixed issue-13, issue-24 and issue-25 in one swoop
- Next up
    - Add notifications for start, cancel and complete
    - Schedule notification deliveries
        - https://github.com/jmettraux/rufus-scheduler
        - Callback through a bin?
            - Makes sense if not using a gem for it
        - Pass a block to execute on completion
        - Making sure I can spawn processes asynchronously
    - Rules
        - One running event at a time
    - CLI
        - straight command line with flags
        - interactive CLI
    - Reporting
        - HTML
        - CLI table printing

## 2014-01-18

- Reading through [POODR](http://www.poodr.com) and feeling the desire for some UML diagramming of the pmd binary with the event classes
    - Sadly, OmniGraffle doesn't seem particularly conducive to building UML sequence diagrams. The stencils don't seem to work for it all that well.

## 2014-01-22

- Looked for UML diagramming tools and it looks like ruby-uml, an old tool, might be helpful
    - Need to install http://sourceforge.net/projects/aspectr-fork/
    - http://ruby-uml.rubyforge.org
    - Dunno if it runs

## 2014-02-10

- Found a potential [new config system](https://github.com/binarylogic/settingslogic)
- Thinking about resolving Issue #23 by making Event a module instead of a class
- Also working on adding in hooks for a adding notifications

## 2014-02-11

- More work on the hooks
- Something I seem to have left off is triggering any sort of method upon a notification completion for notification types
- Not sure why notification is in use there

## 2014-03-03

Thinking through processing more. I built some notes of what needed to be done in my physical notebook. Here's where I think that can go:

- Event generates notifications during a state change
- Start, cancel, complete begin notifications
- Notifications that can be deferred need a separate class vs. ones that are delivered immediately
- deferred notifications can also trigger a state change
- Event is responsible for driving notifications
- calculate seconds of delta before deliver_at is due
- Use process.fork with a sleep value set. When the sleep comes back, deliver the notification, activate the next notification
- At the end of the notification chain, transition state, if a transition is available
    - Check for existence of notifications, if no more, transition
- Clean up old notifications (> 24 hours old)
- Cancel will need to interrupt in-progress notifications, spike any outstanding notifications
    - completed\_at is set to now()

## 2014-03-09

- Created issue-26 for implementing notifications for Pomodori
- Added a failing test


## 2014-03-10

- Rethinking the method signature for both Notifications and Event implementing notifications
    - Notification: Action may not be the most obvious
- I can create a factory for notifications
    - args: event, post-action, notifications (array of hashs, "action", "deliver_at")
        - saves notifications
        - notifications might need to reloaded
    - Likely helpful to draw the sequence diagram
        - Event adds notifications
        - start
            - first notification off the stack is processed
            - once it delivers, next notification is processed
            - ..
            - last notification processes, calls state change, if appropriate


## 2014-03-12

- Defining run method for events which will run "notification"
- Besides the notifications array, I could have "state notifications" that I execute the "run" state out of events and clear state notifications afterward
- I'd fork to go to the notification (which might have a Proc from the event) and not block the interface
- Event *may* need to understand how to repopulate transition notifications
- For testing, I'll need to mock notifications (I want to test a delay, but not a 25 minute one)


## 2014-03-13

- Filling in tests

## 2014-03-14

- Working on calculating delivery delay in Notification
    - Done and hooked in

## 2014-03-15

- The process fork may not be needed apart from the bin segment
    - I'll take that as a first approach and can fall back to Proc passing / callbacks
    - setting-up at jobs is a second option
- Next is implementing Event#clear\_completed\_notifications, wiring in the cli with procs
    - cli should be treated as a controller class
    - should involve writing a pid file
- TODO: rework test around event notifications
    - state notifications won't be reflected because they'll be cleared

## 2014-03-27

- Made a bad assumption looking to state_notifications for testing after running start
    - I can make sure state\_notifications gets called (done)

## 2014-03-29

- Tweaking how I test notifications

## 2014-03-30

- Carrying forward work on cancel, completed, using shared examples
- Next
    - Pausa
    - Lunga pausa
    - Adding a pid / process
    - Potentially using a controller?

## 2014-03-31

- Added tests around cancel and complete notifications in Pomodoro
- TODO: Handle the number of notifications for events programmatically
    - Sample messages
        - "You just started!"
        - "You've completed N minutes"
    - Notify every N minutes (config option?)
    - At least one notification on start and end
    - Logic can expect to be shared by Pomodoro and LungaPausa
    - [Filed](https://github.com/base10/pomodori/issues/27)

## 2014-05-02

- No work in April on this. That's not good. I'm really anxious to get done with this phase and move on to other projects
- Closing out work on #26, moving on to hooking into the pmd class
    - Added #28
- Also added #29 to refactor event notification examples into shared example groups in rspec tests

## 2014-05-16

Listening to the Ruby Rogues podcast, Episode 155, I heard some pieces about Ruby's shortcomings that had me thinking about how to approach the CLI. As mentioned in earlier entries, I plan to use a controller. That controller will be responsible for the forking the request. The forked request should be self-contained, writing a pid to indicate a running pomodoro, but returning control to the CLI for the user to accomplish other actions. I'll also need the notion of a follow-up action (for chaining a pomodoro and a pausa together.

## 2014-09-11

So, been a while since I've done anything with this code. Time to fix that.

- TODO: use Service/controller objects between the CLI and data objects
- Have a number of test failures to address that I left the last time I touched this, apparently.
- Added #30 to upgrade to RSpec 3.1

## 2014-09-12

- Finished RSpec 3.1 upgrade (#30)
- Thinking through what I have to do with issue 28 (Create and attach command line interface), I suspect I should break this down into smaller tasks and build smaller service objects out of those

## 2014-09-15

- I ended up [opening up a Milestone](https://github.com/base10/pomodori/milestones/CLI%20MVP) and opening a number of issues underneath
- TODO: Add a task to move the require_relative statements out of pomodori into the appropriate level of file

## 2014-10-01

- While I was on my way up north for vacation, I started work on service objects
- Created an aggregate argument handler
