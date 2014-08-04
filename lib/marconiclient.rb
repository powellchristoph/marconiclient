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
#      logger.info "prepare_request"
      options = {:headers => { 'Client-ID' => @uuid }}
      req = Request.new("#{@base_url}/v#{@api_version}", options)
    end

#    def create_queues(listing_response)
#      if listing_response[:queues].nil?
#        listing_response[:queues]
#      else
#        queues = Array.new
#        listing_response[:queues].each { |q| queues << Queue.new(self, q[:name])}
#        queues
#      end
#    end

    def queues(options={})
      # Returns a list of queues from the server
      #logger.debug('request queues')
      req = prepare_request
      response = req.queue_list options
      response[:queues]
    end

    def queue(name, auto_create=true)
      # Returns a queue instance
      Queue.new(self, name, auto_create)
    end

    def follow(ref)
      # Follows reference

      # TODO: define queue method
    end

    def health
      #logger.debug('request health')
      req = prepare_request
      req.health
    end

    def home
      req = prepare_request
      req.home
    end

  end
end
