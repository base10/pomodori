# Schema

## events

- id
- summary
- duration
- event_type (enum: pomodoro, break, long_break)
- state (enum: complete, aborted, in_progress)
- started_at
- finished_at

## schema_migrations

- version

## Objects

- Config
- Event (database)
    - Pomodoro
    - Break
        - LongBreak
- Report
- Setup (database + config files, schema)
- Database
