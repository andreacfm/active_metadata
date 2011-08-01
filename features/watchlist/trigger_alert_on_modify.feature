# encoding: UTF-8
Feature: Trigger alert on modify
	In order to alert a user of a modified attribute value or metadata 
	of an ActiveRecord object
	As a user
	I want to find a new notification in my inbox when a watcher is set 
	on a field and a modification on it occurs
                                                    
	Background: 
		Given an ActiveRecord object instance of 'Document'
		And a User "fg@fractalgarden.com" instanciated
	
	Scenario: receive a new alert in the inbox when a save of a field value occurs
		Given a watcher on the "name" field 
		When saving a new value on the "name" field
		Then a new alert should be found in the inbox of the user 


