Active Metadata
====
               
Requirements
---

ActiveMetadata gem will work properly under the following conditions:

*	ActiveMetadata will work _only_ in a Rails 3+ application 
*	a User model having an id and an email attribute MUST be present in the application. This requirement is necessary 
	to correlate the User model to the alert Watcher model.
*   User model must expose a current method that returns the current_user in order to make active_metadata capable to save the user_id	
    http://rails-bestpractices.com/posts/47-fetch-current-user-in-models
*	The Rails application MUST create from scratch or implement a WatcherNotifier class

Concurrency
===

* use the active_metadata_timestamp form helper to pass a correctly formatted timestamps

Tech Debts
---

* in the {active_metadata:setup} task will be generated a sample WatcherNotifier class
  to be changed and implemented accordingly to the rails app logic

* def notify_changes(matched_label, values, model_class, model_id) should not present
  model_class and model_id as parameters but it should take it from a common reference

* Method models/Watcher.notify_changes: it should be better ti get the list of user 
  in one shot to load them from the SQL Database in one shot and not for every watcher

* Fix the setup task for:
    * Migration file copy must come from db/migration and not from a template
    * drop mongoid set up file

* implement controller methods for notes/attachments starred/star/unstar
