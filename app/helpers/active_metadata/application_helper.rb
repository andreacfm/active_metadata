module ActiveMetadata
  module ApplicationHelper
	  def markdown(text)
	    Redcarpet.new(text).to_html.html_safe
	  end

    def stream_partial_path element
      class_name_downcase = clean_class_name element.class.to_s.downcase
      "active_metadata/#{class_name_downcase.pluralize}/#{class_name_downcase}"
    end

    def clean_class_name name
      name.split('::').last || nil
    end
  end
end
