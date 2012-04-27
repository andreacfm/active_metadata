## Rake
I task di rake vengono invocati via il namespace app.

    rake app:ci

## Issues
* The install rake task is destructive. Needs to be refactored as a rails generator using Thor actions.
* The install task should automount the engine as /active_metadata
* Migrations should be available to the rails app that mount the engine and not copied.
* Move the test db creation into before suite rspec callback and remove the migration from the db folder

