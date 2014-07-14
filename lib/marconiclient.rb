require_relative "marconiclient/version"
require_relative "marconiclient/queues"
require_relative "marconiclient/iterator"
require_relative "marconiclient/core"
require_relative "marconiclient/request"

require "securerandom"

module Marconiclient
  class Client
    
    def initialize(url, version=1)
      @base_url = url
      @api_version = version
      @uuid = SecureRandom.hex
    end

    def prepare_request
      puts 'client.prepare_request'
      req = Request.new(@base_url, @api_version)
      req.headers = {'Client-ID' => @uuid}
      req
    end

    def queues(**params)
      # Returns a list of queues from the server
      
      # TODO: define queues method
    end

    def queue(name, **kwargs)
      # Returns a queue instance
      Queue.new(self, name)
    end

    def follow(ref)
      # Follows reference

      # TODO: define queue method
    end

    def health
      puts 'client.health'
      req = prepare_request
      Core.health(req)
    end

    def home
      # GET /v1
      req = self.class.get("/v#{@api_version}", headers: {'Client-ID' => @uuid})
    end

  end
end
