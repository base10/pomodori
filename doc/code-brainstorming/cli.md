# Command Line Interface brainstorming

- The Pomodori gem will have a 'bin' command that will act as the interface.
- The command itself will be pmd.
- pmd will interact with Pomodori::Dispatch to do its work
- The first argument will be the mode.

Now, onto the modes themselves:

## Definite commands, first iteration

This will provide the walking skeleton

- pmd help
    - If no argument is specified, help is assumed
- pmd setup
    - Installs a default config file
    - Sets-up a database and makes sure initial migrations are applied
    - Will only add a config file if one isn't present (for version 1)
- pmd start
    - This will start a new pomodoro (paired with a break)
    - Options
        - summary (text)
            - If not set, a default value is used
        - length (integer)
            - If not set, a default value is used
    - Assumptions
        - The correct type of break (Break vs. LongBreak) is calculate and appended as a predicate event
        - The necessary notifications are set-up
- pmd end
    - End the current event, without altering completed events (pomodoro, break, long break)
    - Cancel outstanding notifications

## Definite commands, second iteration

- pmd break
    - Options
        - summary
        - length
- pmd report
	- Show num of pomodors from the current day, the past work week with breaks, can show times, titles
	- More formatting options
	    - Formatting options (strategies) could be specified in the config file
- pmd update
    - Migrates database schema forward, as necessary
    - Migrates configuration format forward, as necessary

## Still need consideration

- pmd reset
    - Requires confirmation
	- Reset the database to original state
	- Recopy
- pmd pause
