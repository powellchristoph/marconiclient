require 'pp'
require_relative 'logging'
require_relative 'message'

module Marconiclient
  class Queue
    include Logging

    attr_reader :name, :metadata

    def initialize(client, name, auto_create=true)
      @name = name
      @client = client

      #logger.debug('Creating queue instance')
      create if auto_create
    end

    def exists?
      # Checks if the queue exists
      req = @client.prepare_request
      req.queue_exists(@name)
    end

    def create 
      # Creates the given queue
      req = @client.prepare_request
      req.queue_create(@name) unless exists?
    end

    def metadata
      # Get metadata and return it
      #logger.debug 'Checking metadata'
      @metadata ||= @client.prepare_request.queue_get_metadata(@name)
    end

    def set_metadata(meta, merge=true)
      req = @client.prepare_request

      if merge
        #logger.debug 'Merging metadata'
        new_meta = @metadata.merge(meta)
      else
        #logger.debug 'Overwritting metadata'
        new_meta = meta
      end

      #logger.debug 'Setting meta.'
      req.options[:body] = new_meta.to_json
      req.queue_set_metadata(@name)
      @metadata = req.queue_get_metadata(@name)
    end

    def stats
      req = @client.prepare_request
      req.queue_get_stats(@name)
    end

    def delete
      req = @client.prepare_request
      req.queue_delete(@name)
    end

    # Messages API

    def post(messages)
      if messages.class != Array
        messages = [messages]
      end

      req = @client.prepare_request
      req.message_post(@name, messages)
    end

    def message(message_id)
      # Return Message object
      req = @client.prepare_request
      Message.new(req.message_get(@name, message_id))
    end

    def create_messages(response_list)
      msg_list = Array.new
      unless response_list[:messages].empty?
        response_list[:messages].each { |m| msg_list << Message.new(m) }
      end
      msg_list
    end

    def messages(messages: nil, **params)
      # Return array of Messages
      req = @client.prepare_request
      if messages.nil?
        create_messages req.message_list(@name, params)
      else
        create_messages req.message_get_many(@name, messages, params)
        # TODO: return msg_list
      end
    end

    def claim(id=nil, ttl=nil, grace=nil, limit=nil)
    end

  end
end
