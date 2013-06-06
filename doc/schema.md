# Schema

## events

- id
- summary
- duration
- kind (pomodoro, break, long_break)
- state (complete, aborted, in_progress)
- started_at
- completed_at

## notifications

- id
- event_id
- action
    - What's supposed to happen when this notification fires
- deliver_at
- completed_at

## schema_migrations

- version

## Objects

- Config
- Event (database)
    - Pomodoro
    - Break
        - LongBreak
- Notification
- Report
- Setup (database + config files, schema)
- Database
