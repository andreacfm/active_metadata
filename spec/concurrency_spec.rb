require "rspec"

describe "Manage Concurrency" do

  before(:each) do
    @document = Document.create! { |d| d.name = "John" }
    @document.reload
  end

  describe "when a field is modified and the form ts is subsequent of the history ts" do

    it "should save the new value and history must be updated with the latest change" do
        pratica = Factory.create(:pratica);
        sleep 0.2.seconds

        params = {:nome_sito => "nuovo nome sito"}
        warn,fatal = pratica.manage_concurrency params,Time.now
        pratica.update_attributes(params)

        warn.should be_empty
        fatal.should be_empty
        hs = pratica.history_for(:nome_sito)
        hs.count.should eq 2
        hs.first.value.should eq "nuovo nome sito"
        Pratica.last.nome_sito.should eq "nuovo nome sito"
    end

  end

  describe "when a field is modified and the form ts is preceding the history ts" do

    it "should not change the model value and the history if the newest history value is equal to the submitted once, param should be retuned as warning" do
      pratica = Factory.create(:pratica);
      form_timestamp = Time.now
      params = {:nome_sito => "nuovo nome sito"}

      #someone change the field value
      sleep 0.2.seconds
      warn,fatal = pratica.manage_concurrency params,Time.now
      pratica.update_attributes(params)

      # user submit pushing the same value that was already saved by another user
      sleep 0.2.seconds
      warn,fatal = pratica.manage_concurrency params,form_timestamp
      pratica.update_attributes(params)

      warn.size.should eq 1
      warn[0][:nome_sito][0].should eq "nuovo nome sito"
      fatal.should be_empty
      hs = pratica.history_for(:nome_sito)
      #last change shoudl not be recorded in history
      hs.count.should eq 2
      hs.first.value.should eq "nuovo nome sito"
      Pratica.last.nome_sito.should eq "nuovo nome sito"

    end

    it "should reject the change if the history newest value is different from the submitted once, param should be returned as fatal" do
      pratica = Factory.create(:pratica);
      form_timestamp = Time.now
      params = {:nome_sito => "nuovo nome sito"}

      #someone change the field value
      sleep 0.2.seconds
      warn,fatal = pratica.manage_concurrency params,Time.now
      pratica.update_attributes(params)

      # user submit a new value
      sleep 0.2.seconds
      different_params = {:nome_sito => "altro nome sito"}
      warn,fatal = pratica.manage_concurrency different_params,form_timestamp
      pratica.update_attributes(different_params)

      fatal.size.should eq 1
      fatal[0][:nome_sito][0].should eq "altro nome sito"
      warn.should be_empty
      hs = pratica.history_for(:nome_sito)
      #last change shoudl not be recorded in history
      hs.count.should eq 2
      hs.first.value.should eq "nuovo nome sito"
      Pratica.last.nome_sito.should eq "nuovo nome sito"

    end

    it "should return both fatals and warnings if required" do
      pratica = Factory.create(:pratica);
      form_timestamp = Time.now
      params = {:nome_sito => "nuovo nome sito", :ok_commerciale => false}

      #someone change the field value
      sleep 0.2.seconds
      warn,fatal = pratica.manage_concurrency params,Time.now
      pratica.update_attributes(params)

      # user submit a new value
      sleep 0.2.seconds
      different_params = {:nome_sito => "altro nome sito", :ok_commerciale => false}
      warn,fatal = pratica.manage_concurrency different_params,form_timestamp
      pratica.update_attributes(different_params)

      fatal.size.should eq 1
      fatal[0][:nome_sito][0].should eq "altro nome sito"
      warn.size.should eq 1
      warn[0][:ok_commerciale][0].should eq false
    end

  end

end