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

