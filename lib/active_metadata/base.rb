require "mongo"
module ActiveMetadata
  HISTORY_SKIPS = ['id', 'created_at', 'updated_at']

  env = defined?(Rails) ? Rails.env : ENV['DATABASE_ENV']
  unless env.nil?
    CONFIG = YAML.load_file('config/mongo.yml')[env]
    CONNECTION = Mongo::Connection.new(CONFIG['host'], CONFIG['port']).db CONFIG['database']
  end

  def self.notes
    CONNECTION['notes']
  end

  def self.history
    CONNECTION['history']
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

        ActiveMetadata.notes.insert :note => note, :id => metadata_id, :field => field, :created_at => Time.now.utc, :created_by => created_by, :updated_at => Time.now.utc
      end

      def update_note id, note, updated_by=nil
        ActiveMetadata.notes.update({:_id => id}, {"$set" => {:note => note, :updated_at => Time.now.utc, :updated_by => updated_by}})
      end

      def notes_for field
        ActiveMetadata.notes.find({:id => metadata_id, :field => field}, {:sort => [[:updated_at, 'descending']]}).to_a
      end

      def create_notes_for field, notes
        notes.each do |note|
          create_note_for field, note
        end
      end

      def delete_note id
        ActiveMetadata.notes.remove({:_id => id})
      end

        # History
      def save_history
        self.changes.each do |key, value|
          next if ActiveMetadata::HISTORY_SKIPS.include?(key)
          ActiveMetadata.history.insert :id => metadata_id, :field => key, :value => value[1], :created_at => Time.now.utc
        end
      end

      def history_for field
        ActiveMetadata.history.find({:id => metadata_id, :field => field}, {:sort => [[:created_at, 'descending']]}).to_a
      end

    end # InstanceMethods
  end

end

::ActiveRecord::Base.send :include, ActiveMetadata::Base
