module ActiveMetadata::ValueFormatter
  extend ActiveSupport::Concern

  def value
    instance = model_class.constantize.new
    return read_attribute(:value).to_s unless instance.respond_to?(label.to_sym)
    instance.send :write_attribute, label.to_sym, read_attribute(:value)
    instance.send label
  end

end

