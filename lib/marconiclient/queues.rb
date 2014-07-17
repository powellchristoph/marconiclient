require 'pp'
require_relative 'logging'

module Marconiclient
  class Queue
    include Logging

    attr_reader :name, :metadata

    def initialize(client, name, auto_create=true)
      @name = name
      @client = client

      logger.debug('Creating queue instance')
      ensure_exists if auto_create
    end

    def exists?
      # Checks if the queue exists
      req = @client.prepare_request
      req.queue_exists(@name)
    end

    def ensure_exists
      # Ensure the queue exists
      req = @client.prepare_request
      req.queue_create(@name) unless exists?
    end

    def metadata
      # Get metadata and return it
      logger.debug 'Checking metadata'
      @metadata ||= @client.prepare_request.queue_get_metadata(@name)
    end

    def set_metadata(meta, merge=true)
      req = @client.prepare_request
      if merge
        # merge the docuemnts and set
      else 
        logger.debug 'Overwritting meta.'
        req.options[:body] = meta.to_json
        req.queue_set_metadata(@name)
        @metadata = req.queue_get_metadata(@name)
      end
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
    end

    def message(message_id)
    end

    def messages(*messages, **params)
    end

    def claim(id=nil, ttl=nil, grace=nil, limit=nil)
    end

  end
end
