# encoding: UTF-8
Feature: Add a user to a watcher
	In order to alert a user of a modified attribute value or metadata 
	of an ActiveRecord object
	As a user
	I want add myself to the list of users for that attribute that will 
	be notified when that value or metadata will be changed by someone
                                                    
	Background: 
		Given an ActiveRecord object instance of 'Document'
		And an ActiveRecord object instance of 'User'
	
	Scenario: creates a watcher for an attribute and add a user to its list
		Given a User "fg@fractalgarden.com"
		When adding the user to the watcherslist of an attribute "name"
		And not finding a watcher for that field
		Then it should be created a new watcher for that field 
		And added a user to the list of the watcher 

	Scenario: add a user to a watcher list that already exists for an attribute
		Given a User "fg@fractalgarden.com"
		When adding the user to the watcherslist of an attribute "name"
		And finding a watcher for that field
		Then the user should be added to that watcher




