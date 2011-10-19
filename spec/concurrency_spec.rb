require "spec_helper"

describe "Manage Concurrency" do

  before(:each) do
    @document = Document.create! { |d| d.name = "John" }
    @document.reload
  end

  describe "when a field is modified and the form ts is subsequent of the history ts" do

    it "should save the new value and history must be updated with the latest change" do
        sleep 0.2.seconds

        params = {:name => "nuovo nome"}
        warn,fatal = @document.manage_concurrency params,Time.now
        @document.update_attributes(params)

        warn.should be_empty
        fatal.should be_empty
        hs = @document.history_for(:name)
        hs.count.should eq 2
        hs.first.value.should eq "nuovo nome"
        Document.last.name.should eq "nuovo nome"
    end

  end

  describe "when a field is modified and the form ts is preceding the history ts" do

    it "should not change the model value and the history if the newest history value is equal to the submitted once, param should be retuned as warning" do
      form_timestamp = Time.now
      params = {:name => "nuovo nome"}

      #someone change the field value
      sleep 0.2.seconds
      warn,fatal = @document.manage_concurrency params,Time.now
      @document.update_attributes(params)

      # user submit pushing the same value that was already saved by another user
      sleep 0.2.seconds
      warn,fatal = @document.manage_concurrency params,form_timestamp
      @document.update_attributes(params)

      warn.size.should eq 1
      warn[0][:name][0].should eq "nuovo nome"
      fatal.should be_empty
      hs = @document.history_for(:name)
      #last change shoudl not be recorded in history
      hs.count.should eq 2
      hs.first.value.should eq "nuovo nome"
      Document.last.name.should eq "nuovo nome"

    end

    it "should reject the change if the history newest value is different from the submitted once, param should be returned as fatal" do
      form_timestamp = Time.now
      params = {:name => "nuovo nome"}

      #someone change the field value
      sleep 0.2.seconds
      warn,fatal = @document.manage_concurrency params,Time.now
      @document.update_attributes(params)

      # user submit a new value
      sleep 0.2.seconds
      different_params = {:name => "altro nome"}
      warn,fatal = @document.manage_concurrency different_params,form_timestamp
      @document.update_attributes(different_params)

      fatal.size.should eq 1
      fatal[0][:name][0].should eq "altro nome"
      warn.should be_empty
      hs = @document.history_for(:name)
      #last change shoudl not be recorded in history
      hs.count.should eq 2
      hs.first.value.should eq "nuovo nome"
      Document.last.name.should eq "nuovo nome"

    end

    it "should return both fatals and warnings if required" do
      form_timestamp = Time.now
      params = {:name => "nuovo nome", :keep_alive => false}

      #someone change the field value
      sleep 0.2.seconds
      warn,fatal = @document.manage_concurrency params,Time.now
      @document.update_attributes(params)

      # user submit a new value
      sleep 0.2.seconds
      different_params = {:name => "altro nome", :keep_alive => false}
      warn,fatal = @document.manage_concurrency different_params,form_timestamp
      @document.update_attributes(different_params)

      fatal.size.should eq 1
      fatal[0][:name][0].should eq "altro nome"
      warn.size.should eq 1
      warn[0][:keep_alive][0].should eq false
    end

  end

end