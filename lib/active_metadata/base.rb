require "mongo"
require "fileutils"
require "ostruct"
require "active_metadata/attachment"
require "active_metadata/note"
require "active_metadata/history"

module ActiveMetadata

  HISTORY_SKIPS = ['id', 'created_at', 'updated_at']

  if File.exists? 'config/active_metadata.yml' #this allows install task to run
    CONFIG = YAML.load_file('config/active_metadata.yml')[Rails.env]
    DB_CONFIG = YAML.load_file('config/mongo.yml')[Rails.env]
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
        include ActiveMetadata::Attachment::InstanceMethods
        include ActiveMetadata::Note::InstanceMethods
        include ActiveMetadata::History::InstanceMethods
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

      private
      def to_open_struct arr, &block
        res = []
        arr.each do |item|
          os = OpenStruct.new item
          block.call os if block_given?
          res.push(os)
        end
        res
      end

    end # InstanceMethods
  end

end

::ActiveRecord::Base.send :include, ActiveMetadata::Base


