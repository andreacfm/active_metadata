# encoding: UTF-8
                                           
Given /^an ActiveRecord instance of 'Document' with 'name' equals to "([^"]*)"$/ do |name|
  raise unless Document.ancestors.include?(::ActiveRecord::Base)
  @document = Document.create!(:name => name, :surname => 'Garden' )
end

Given /^a User "([^"]*)" instanciated$/ do |email|
  @current_user = User.create!(:email => email, :firstname => 'John', :lastname => 'smith' )
end

Given /^a watcher on the "([^"]*)" field$/ do |attribute|
  @attribute = attribute
  @document.create_watcher_for(@attribute, @current_user)
end

When /^saving a new value "([^"]*)" on the "([^"]*)" field$/ do |value, attribute|
  @document.send("#{attribute}=", value)
  @document.save!
end

Then /^a new alert should be found in the inbox of the user$/ do
  @current_user.inbox.messages.should have(1).record
  @message = @current_user.inbox.messages.first  
end
                                           

Then /^should regard the "([^"]*)" field$/ do |field|
  @message.label.should == field
end

Then /^should record the "([^"]*)" model class$/ do |model_class|
  @message.model_class.should == model_class
end

Then /^should record the new value "([^"]*)"$/ do |new_value|
  @message.new_value.should == new_value
end

Then /^the old value "([^"]*)"$/ do |old_value|
  @message.old_value.should == old_value
end
