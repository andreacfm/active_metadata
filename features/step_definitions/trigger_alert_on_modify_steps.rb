# encoding: UTF-8

Given /^a User "([^"]*)" instanciated$/ do |email|
  @current_user = User.create!(:email => email, :firstname => 'John', :lastname => 'smith' )
end

Given /^a watcher on the "([^"]*)" field$/ do |attribute|
  @attribute = attribute
  @document.create_watcher_for(@attribute, @current_user)
end

When /^saving a new value on the "([^"]*)" field$/ do |attribute|
  @document.send("#{attribute}=", "Rose")
  @document.save!
end

Then /^a new alert should be found in the inbox of the user$/ do
  @current_user.inbox.messages.should have(1).record
end
