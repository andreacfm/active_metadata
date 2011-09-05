== Active Metadata
               
== Requirements
ActiveMetadata gem will work properly under the following conditions. 
*	ActiveMetadata will work _only_ in a Rails 3+ application 
*	a User model having an id and an email attribute MUST be present in the application. This requirement is necessary 
	to correlate the User model to the alert inbox of the Watchers model.
* 	a migration must be created and launched to make the rails web application function properly. In a future
	version there will be a task to create this migration but ATM it should be made by hand
the following code is the migration to be added to generate the Inbox and AlertMessage corresponsing 
tables that are already present in this gem so *no model creation* is necessary in the hosting 
rails web app. 

	class SetupActiveMetadata < ActiveRecord::Migration
	  def self.up
    
	    create_table :inboxes do |t|
	      t.integer :user_id
	    end
    
	    create_table :alert_messages do |t|
	      t.string :label
	      t.string :model_class
	      t.integer :model_id
	      t.string :alert_type
	      t.string :old_value
	      t.string :new_value
	      t.text :content
	      t.integer :inbox_id
	      t.timestamps
	    end    
	  end

	  def self.down       
	    drop_table :alert_messages    
	    drop_table :inboxes
	  end  
	end

----
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
----

== Tech Debts

* The migration to create the inboxes table should automagically being created by 
  a generator or a rake task like {rake active_metadata:setup}

* Method models/Watcher.notify_changes: it should be better ti get the list of user 
	in one shot to load them from the SQL Database in one shot and not for every watcher
* the inbox now contains just one object and it should contain a number of alerts

*   def notify_changes(matched_label, values, model_class, model_id) should not present
	model_class and model_id as parameters but it should take it from a common reference	