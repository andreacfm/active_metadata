module ActiveMetadata
  module StreamHelper

    def stream_partial_path element
      class_name_downcase = element.class.to_s.downcase
      "active_metadata/#{class_name_downcase.pluralize}/#{class_name_downcase}"
    end

  end
end
