require 'pp'
require_relative 'logging'

module Marconiclient
  class Queue
    include Logging

    attr_reader :name

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
      req.queue_create(@name)
    end

    def stats
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
