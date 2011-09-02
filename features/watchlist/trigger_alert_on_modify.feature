# encoding: UTF-8
Feature: Trigger alert on modify
	In order to alert a user of a modified attribute value or metadata 
	of an ActiveRecord object
	As a user
	I want to find a new notification in my inbox when a watcher is set 
	on a field and a modification on it occurs
                                                    
	Background: 
		Given an ActiveRecord instance of 'Document' with 'name' equals to "pippo"
		And a User "fg@fractalgarden.com" instantiated
	
	Scenario: receive a new alert in the inbox when a save of a field value occurs
		Given a watcher on the "name" field 
		When saving a new value "pluto" on the "name" field
		Then 1 alert should be found in the inbox of the user 
		And should regard the "name" field 
		And should record the "Document" model class 
		And should record the new value "pluto"
		And the old value "pippo"
		
	Scenario: receive a new alert in the inbox when a note of a field is added
		Given a watcher on the "name" field 
		When creating a new note on the "name" field with content "new note!"
		Then 1 alert should be found in the inbox of the user 
		And should regard the "name" field 
		And should record the "Document" model class 
		And should record the "new note!" content

	Scenario: receive a new alert in the inbox when a note of a field is updated
		Given a watcher on the "name" field 
		When creating a new note on the "name" field with content "new note!"
		And afterwards I update the note on the field "name" with content "updated note!"
		Then 2 alert should be found in the inbox of the user 
		And should regard the "name" field 
		And should record the "Document" model class 
		And should record the "updated note!" content

	Scenario: receive a new alert in the inbox when a note of a field is updated
		Given a watcher on the "name" field 
		When creating a new note on the "name" field with content "new note!"
		And afterwards I delete the note on the field "name"
		Then 2 alert should be found in the inbox of the user 
		And should regard the "name" field 
		And should record the "Document" model class 
		And should record the "new note!" content in the old_value 
		And should record the "" in the new_value
