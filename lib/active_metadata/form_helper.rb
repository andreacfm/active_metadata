module ActionView
  module Helpers
    class FormBuilder

      def active_metadata_timestamp
        @template.hidden_field_tag "#{@object_name}[active_metadata_timestamp]", Time.now.to_f
      end

    end
  end
end