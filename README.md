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
*	The Rails application MUST create from scratch implement a WatcherNotifier class 
* 	a migration must be created and launched to make the rails web application function properly. In a future
	version there will be a task to create this migration but ATM it should be made by hand
	                                                                                
Here are a sample of the *User* model to be inserted

	# encoding: utf-8
	class User < ActiveRecord::Base  
	  set_table_name :users  

	  has_one :inbox
	end
	  
and a sample migration to be created

	create_table :users do |t|
	  t.string :email
	  t.string :firstname
	  t.string :lastname
	  t.timestamps
	end

Tech Debts
---

* Add metadata support for more than one model in the same application. Actually only the document_id is stored and searched.
  A solution can be store also a metadata_model_name as we now dow with the metadata_id method. Then searching also based on this parameter.

* The migration to create the inboxes table should automagically be created by 
  a generator or a rake task like {rake active_metadata:setup}

* in the {active_metadata:setup} task will be generated a sample WatcherNotifier class
  to be changed and implemented accordingly to the rails app logic

* the inbox now contains just one object and it should contain a number of alerts

* def notify_changes(matched_label, values, model_class, model_id) should not present
  model_class and model_id as parameters but it should take it from a common reference
* active_metadata.yml in the host rails app should be generated from a setup step like
  rake active_metadata:install
	
* Method models/Watcher.notify_changes: it should be better ti get the list of user 
  in one shot to load them from the SQL Database in one shot and not for every watcher
	
* Saving the model name into histories, notes etc... records could allow the gem to be used 
  for more models into the same applications. As per the id also the model name should consider the presence of a a
  parent.	
