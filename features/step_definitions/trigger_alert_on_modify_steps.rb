# encoding: UTF-8

# Given ##########################################################                                           
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

# When ##########################################################
When /^saving a new value "([^"]*)" on the "([^"]*)" field$/ do |value, attribute|
  @document.send("#{attribute}=", value)
  @document.save!
end

When /^creating a new note on the "([^"]*)" field with content "([^"]*)"$/ do |field, content|
  @document.create_note_for(field.to_sym, content)
end
   
When /^afterwards I update the note on the field "([^"]*)" with content "([^"]*)"$/ do |field, content|
  note = @document.notes_for(field.to_sym).first
  @document.update_note(note.id, content)
end

When /^afterwards I delete the note on the field "([^"]*)"$/ do |field|
  note = @document.notes_for(field.to_sym).first
  @document.delete_note(note.id)
end

When /^creating a new attachment on the "([^"]*)" field with name "([^"]*)"$/ do |field, filename|
  file = File.expand_path("../../supports/#{filename}", __FILE__)
  @attachment = Rack::Test::UploadedFile.new(file, "plain/text")
  @document.save_attachment_for(field.to_sym, @attachment)
  @document.attachments_for(field.to_sym).should have(1).record
end

When /^deleting the attachment on the "([^"]*)" field with name "([^"]*)"$/ do |field, filename|
  @attachment = @document.attachments_for(field.to_sym).last  
  @document.delete_attachment(@attachment.id)
end
                       
When /^updating the attachment on the "([^"]*)" field with name "([^"]*)"$/ do |field, filename|
  @attachment = @document.attachments_for(field.to_sym).last  
  file = File.expand_path("../../supports/#{filename}", __FILE__)
  updated_file = Rack::Test::UploadedFile.new(file, "plain/text")
  
  @document.update_attachment(@attachment.id, updated_file)
end
# Then ##########################################################
Then /^([^"]*) alert should be found in the inbox of the user$/ do |number|
  @notifier = @document.notifier
  # @current_user.inbox.messages.should have(number.to_i).record
  # @message = @current_user.inbox.messages.last
end                                          

Then /^should regard the "([^"]*)" field$/ do |field|
  @notifier.matched_label.should == field
end

Then /^should record the "([^"]*)" model class$/ do |model_class|
  @notifier.model_class.should == model_class
end

Then /^should record the "([^"]*)" in the old_value$/ do |old_value|
  @notifier.old_value.should == old_value
end

Then /^should record the "([^"]*)" in the new_value$/ do |new_value|
  @notifier.new_value.should == new_value
end

Then /^should record the "([^"]*)" in the type$/ do |type|
  @notifier.type.to_s.should == type
end

Then /^should record the current_user_id in the created_by$/ do
  @notifier.created_by.to_i.should == User.current.id
end

Then /^should record the "([^"]*)" in type$/ do |type|
  @notifier.type.to_s.should eq type
end
