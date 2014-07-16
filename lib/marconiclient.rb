require "marconiclient/version"
require "marconiclient/queues"
require "marconiclient/request"
require "marconiclient/logging"

require "securerandom"

module Marconiclient
  class Client
    include Logging
    
    def initialize(url, version=1)
      @base_url = url
      @api_version = version
      @uuid = SecureRandom.hex
    end

    def prepare_request
      logger.info "prepare_request"
      options = {:headers => { 'Client-ID' => @uuid }}
      req = Request.new("#{@base_url}/v#{@api_version}", options)
    end

    def queues(**params)
      # Returns a list of queues from the server
      logger.debug('request queues')
      req = prepare_request
      req.queue_list
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
      logger.debug('request health')
      req = prepare_request
      req.health
    end

  end
end
