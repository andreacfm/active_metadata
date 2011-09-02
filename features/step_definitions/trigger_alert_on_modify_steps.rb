# encoding: UTF-8
                                           
Given /^an ActiveRecord instance of 'Document' with 'name' equals to "([^"]*)"$/ do |name|
  raise unless Document.ancestors.include?(::ActiveRecord::Base)
  @document = Document.create!(:name => name, :surname => 'Garden' )
end

Given /^a User "([^"]*)" instantiated$/ do |email|
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

When /^creating a new note on the "([^"]*)" field with content "([^"]*)"$/ do |field, content|
  @document.create_note_for(field.to_sym, content)
end
   
When /^afterwards I update the note on the field "([^"]*)" with content "([^"]*)"$/ do |field, content|
  note = @document.notes_for(field.to_sym).first
  @document.update_note(note.id, content, @current_user.email)
end

Then /^([^"]*) alert should be found in the inbox of the user$/ do |number|
  @current_user.inbox.messages.should have(number.to_i).record
  @message = @current_user.inbox.messages.last
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
      
Then /^should record the "([^"]*)" content$/ do |value|
  @message.new_value.should == value
end