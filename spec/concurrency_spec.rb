require "spec_helper"

describe "Manage Concurrency" do

  before(:each) do
    @document = Document.create! { |d| d.name = "John" }
    @document.reload
  end

  it "should assign the active_metadata_timestamp via mass assignment" do
    ts = Time.now
    params = {:name => "nuovo nome", :active_metadata_timestamp => ts}
    @document.update_attributes params
    @document.active_metadata_timestamp.should eq ts
  end

  it "should skip if no timestamp is provided" do
    @document.update_attributes :name => "nuovo nome"
    @document.conflicts.should be_nil
  end

  describe "when a field is modified and the form ts is subsequent of the history ts" do

    it "should save the new value and history must be updated with the latest change" do
        sleep 0.2.seconds

        params = {:name => "nuovo nome", :active_metadata_timestamp => Time.now}
        @document.update_attributes(params)

        @document.conflicts[:warnings].should be_empty
        @document.conflicts[:fatals].should be_empty

        hs = @document.history_for(:name)
        hs.count.should eq 2
        hs.first.value.should eq "nuovo nome"
        Document.last.name.should eq "nuovo nome"
    end

  end

  describe "when a field is modified and the form ts is preceding the history ts" do

    it "should not change the model value and the history if the newest history value is equal to the submitted once, param should be retuned as warning" do
      form_timestamp = Time.now

      #someone change the field value
      sleep 0.2.seconds
      @document.update_attributes({:name => "nuovo nome", :active_metadata_timestamp => Time.now})

      # user submit pushing the same value that was already saved by another user
      sleep 0.2.seconds
      @document.update_attributes({:name => "nuovo nome", :active_metadata_timestamp => form_timestamp})

      warnings = @document.conflicts[:warnings]
      warnings.size.should eq 1
      warnings[0][:name][0].should eq "nuovo nome"

      @document.conflicts[:fatals].should be_empty
      hs = @document.history_for(:name)
      #last change shoudl not be recorded in history
      hs.count.should eq 2
      hs.first.value.should eq "nuovo nome"
      Document.last.name.should eq "nuovo nome"

    end

    it "should reject the change if the history newest value is different from the submitted once, param should be returned as fatal" do
      #fixtures
      form_timestamp = Time.now
      params = {:name => "nuovo nome"}

      #someone change the field value
      sleep 0.2.seconds
      @document.update_attributes(params)

      # user submit a new value
      sleep 0.2.seconds
      different_params = {:name => "altro nome", :active_metadata_timestamp => form_timestamp}
      @document.update_attributes(different_params)

      #assetions
      fatals = @document.conflicts[:fatals]
      fatals.size.should eq 1
      fatals[0][:name][0].should eq "altro nome"
      @document.conflicts[:warnings].should be_empty
      hs = @document.history_for(:name)
      hs.count.should eq 2
      hs.first.value.should eq "nuovo nome"
      Document.last.name.should eq "nuovo nome"

    end

    it "should return both fatals and warnings if required" do
      form_timestamp = Time.now
      params = {:name => "nuovo nome", :keep_alive => false}

      #someone change the field value
      sleep 0.2.seconds
      @document.update_attributes params

      # user submit a new value
      sleep 0.2.seconds
      different_params = {:name => "altro nome", :keep_alive => false, :active_metadata_timestamp => form_timestamp}
      @document.update_attributes(different_params)

      fatals = @document.conflicts[:fatals]
      fatals.size.should eq 1
      fatals[0][:name][0].should eq "altro nome"
      warnings = @document.conflicts[:warnings]
      warnings.size.should eq 1
      warnings[0][:keep_alive][0].should eq false
    end

  end

end