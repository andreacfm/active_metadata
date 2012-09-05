module ActiveMetadata
  class History < ActiveRecord::Base
    self.table_name = "active_metadata_histories"

    def value
      instance = document_class.constantize.new
      return read_attribute(:value).to_s unless instance.respond_to?(label.to_sym)
      instance.send :write_attribute, label.to_sym, read_attribute(:value)
      instance.send label
    end

  end
end
