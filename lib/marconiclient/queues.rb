require 'pp'


module Marconiclient
  class Queue

    def initialize(client, name, auto_create=true)
      @name = name
      @client = client

      pp 'client: ', @client
      puts 'name: ', @name

      ensure_exists if auto_create
    end

    def exists?
      # Checks if the queue exists
      req = @client.prepare_request
      Core.queue_exists(req, @name)
    end

    def ensure_exists
      # Ensure the queue exists
      req = @client.prepare_request
      Core.queue_create(req, @name)
    end

    def stats
    end

    def delete
      req = @client.prepare_request
      Core.queue_delete(req, @name)
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
