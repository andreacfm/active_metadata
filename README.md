## Rake
I task di rake vengono invocati via il namespace app.

    rake app:ci

## Issues
* The install rake task is destructive. Needs to be refactored as a raila generator using Thor actions.
* The install task should automount the engine as /active_metadata

