require "mongo"
module ActiveMetadata
  HISTORY_SKIPS = ['id', 'created_at', 'updated_at']

  env = Rails.env
  unless env.nil?
    CONFIG = YAML.load_file('config/active_metadata.yml')[env]
    DB_CONFIG = YAML.load_file('config/mongo.yml')[env]
    #CONNECTION = Mongo::ReplSetConnection.new(['localhost', 27017], ['localhost', 27018], ['localhost', 27019]).db CONFIG['database']
    CONNECTION = Mongo::Connection.new(DB_CONFIG['host'], DB_CONFIG['port']).db DB_CONFIG['database']
  end

  def self.notes
    CONNECTION['notes']
  end

  def self.history
    CONNECTION['history']
  end

  def self.attachments
    CONNECTION['attachments']
  end

    # Ensure retry upon failure
  def self.safe_connection(max_retries=60)
    retries = 0
    begin
      yield
    rescue Mongo::ConnectionFailure => ex
      retries += 1
      raise ex if retries > max_retries
      sleep(1.second)
      retry
    end
  end

    ## Define ModelMethods
  module Base

    def self.included(klass)
      klass.class_eval do
        extend Config
      end
    end

    module Config

      def acts_as_metadata *args
        after_save :save_history
        class_variable_set("@@metadata_id_from", args.empty? ? nil : args[0][:metadata_id_from])
        include ActiveMetadata::Base::InstanceMethods
      end

    end

    module InstanceMethods

      def metadata_id
        metadata_id_from = self.class.class_variable_get("@@metadata_id_from")
        return self.id if metadata_id_from.nil?
        receiver = self
        metadata_id_from.each do |item|
          receiver = receiver.send item
        end
        receiver.id
      end

        # NOTES
      def create_note_for(field, note, created_by=nil)
        raise RuntimeError, "The object id MUST be valued" unless self.id
        ActiveMetadata.safe_connection do
          ActiveMetadata.notes.insert :note => note, :id => metadata_id, :field => field, :created_at => Time.now.utc, :created_by => created_by, :updated_at => Time.now.utc
        end
      end

      def update_note id, note, updated_by=nil
        ActiveMetadata.safe_connection do
          ActiveMetadata.notes.update({:_id => id}, {"$set" => {:note => note, :updated_at => Time.now.utc, :updated_by => updated_by}})
        end
      end

      def notes_for field
        ActiveMetadata.safe_connection do
          ActiveMetadata.notes.find({:id => metadata_id, :field => field}, {:sort => [[:updated_at, 'descending']]}).to_a
        end
      end

      def create_notes_for field, notes
        notes.each do |note|
          create_note_for field, note
        end
      end

      def delete_note id
        ActiveMetadata.safe_connection do
          ActiveMetadata.notes.remove({:_id => id})
        end
      end

        # History
      def save_history
        self.changes.each do |key, value|
          next if ActiveMetadata::CONFIG['history_skip_fields'].include?(key)
          ActiveMetadata.safe_connection do
            ActiveMetadata.history.insert :id => metadata_id, :field => key, :value => value[1], :created_at => Time.now.utc
          end
        end
      end

      def history_for field
        ActiveMetadata.safe_connection do
          ActiveMetadata.history.find({:id => metadata_id, :field => field}, {:sort => [[:created_at, 'descending']]}).to_a
        end
      end

        #Attachments
      def save_attachment_for field, file
        ActiveMetadata.safe_connection do
          ActiveMetadata.attachments.insert({
              :id => metadata_id,
              :field => field,
              :attachment_file_name => file.original_filename,
              :attachment_content_type => file.content_type,
              :attachment_size => file.size,
              :attachment_updated_at => Time.now.utc,
              :attachment_relative_path => "/#{metadata_id}/#{field.to_s}"
          })
        end
      end

      def attachments_for field
        ActiveMetadata.safe_connection do
          ActiveMetadata.attachments.find({:field => field}).to_a
        end
      end

    end # InstanceMethods
  end

end

::ActiveRecord::Base.send :include, ActiveMetadata::Base


