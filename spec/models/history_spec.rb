require "spec_helper"


describe ActiveMetadata::History do

  describe "#value" do

    before do
      @h1 = ActiveMetadata::History.create! document_class: "Document", label: "name", value: "nome"
      @h2 = ActiveMetadata::History.create! document_class: "Document", label: "keep_alive", value: true
      @h3 = ActiveMetadata::History.create! document_class: "Document", label: "date", value: Time.now
      @h4 = ActiveMetadata::History.create! document_class: "Document", label: "price", value: 10.12
      @h5 = ActiveMetadata::History.create! document_class: "Document", label: "average", value: 10.123
      @h6 = ActiveMetadata::History.create! document_class: "Document", label: "does_not_exists", value: "pippo"
    end

    specify{ @h1.value.should eq "nome" }
    specify{ @h2.value.should eq true }
    specify{ @h3.value.should be_kind_of ActiveSupport::TimeWithZone }
    specify{ @h4.value.should be_kind_of BigDecimal }
    specify{ @h4.value.to_s.should eq "10.12" }
    specify{ @h5.value.should be_kind_of BigDecimal }
    specify{ @h5.value.to_s.should eq "10.123" }
    specify{ @h6.value.to_s.should eq "pippo" }


  end
  
end