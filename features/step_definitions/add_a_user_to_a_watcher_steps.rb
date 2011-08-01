# encoding: UTF-8

### Background #
Given /^an ActiveRecord object instance of 'Document'$/ do
  raise unless Document.ancestors.include?(::ActiveRecord::Base)
  @document = Document.create!(:name => 'Fractal', :surname => 'Garden' )
end

Given /^an ActiveRecord object instance of 'User'$/ do
  raise unless User.ancestors.include?(::ActiveRecord::Base)
end
  
### Scenarios #        
Given /^a User "([^"]*)"$/ do |email|
  @current_user = User.create!(:email => email, :firstname => 'John', :lastname => 'smith' )
end

When /^adding the user to the watcherslist of an attribute "([^"]*)"$/ do |attribute|
  @attribute = attribute
  @document.create_watcher_for(@attribute, @current_user)
end

When /^not finding a watcher for that field$/ do
  # noop
end

Then /^it should be created a new watcher for that field$/ do
  @document.watchers_for(@attribute).should_not be_nil
end

Then /^added a user to the list of the watcher$/ do                     
  puts  @document.watchers_for(@attribute)
  @document.watchers_for(@attribute).user_ids.should include?(@current_user.id)
end

When /^finding a watcher for that field$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^the user should be added to that watcher$/ do
  pending # express the regexp above with the code you wish you had
end
