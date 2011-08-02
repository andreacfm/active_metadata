== Active Metadata

== Tech Debts

* The migration to create the inboxes table should automagically being created by 
  a generator or a rake task like {rake active_metadata:setup}

* Method models/Watcher.notify_changes: it should be better ti get the list of user 
	in one shot to load them from the SQL Database in one shot and not for every watcher
* the inbox now contains just one object and it should contain a number of alerts
	