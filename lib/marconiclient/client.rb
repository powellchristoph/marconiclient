#require File.join(File.dirname(__FILE__), "queues")
#require File.join(File.dirname(__FILE__), "iterator")
#require File.join(File.dirname(__FILE__), "request")

require_relative 'queues'
require_relative 'iterator'
require_relative 'request'

module Marconiclient

  class Client
    # Client base class
    
    def initialize
      @api_url = url
      @api_version = 1
      @client_uuid = ''
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
