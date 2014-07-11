require_relative "marconiclient/version"
require_relative "marconiclient/queues"
require_relative "marconiclient/iterator"

require "securerandom"

module Marconiclient
  class Client
    
    def initialize(url, version=1)
      @api_url = url
      @api_version = version
      @client_uuid = SecureRandom.hex
    end

    def queues(**params)
      # Returns a list of queues from the server
      
      # TODO: define queues method
    end

    def queue(ref, **kwargs)
      # Returns a queue instance

      # TODO: define queue method
    end

    def follow(ref)
      # Follows reference

      # TODO: define queue method
    end

  end
end
